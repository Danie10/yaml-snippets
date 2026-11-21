#!/bin/bash
set -euo pipefail
# OMV: update the locally built dockhand-mcp image to the latest GitHub *release tag* and recreate its container.
#   ./dockhandmcpupdate.sh check   -> only report whether a newer release exists
#   ./dockhandmcpupdate.sh         -> report, ask, then update
#   ./dockhandmcpupdate.sh -y      -> update without asking
#   ./dockhandmcpupdate.sh 0.4.0   -> install a specific release tag (e.g. to roll back)
# The script starts by changing to the directory where the build was done, so your BASE may be different
BASE="/APPDATA/Config/dockhand-mcp"
REPO="${BASE}/src"
STACK="/APPDATA/Config/dockhand/stacks/omv/dockhand-mcp"
TS="$(date +%F_%H%M%S)"

git() { docker run --rm -v "${BASE}:/w" -w /w/src alpine/git -c safe.directory=* "$@"; }

cd "${REPO}"
git fetch -q --tags --force origin
LATEST="$(git tag --sort=-v:refname | grep -E "^v?[0-9]+\.[0-9]+\.[0-9]+$" | head -1)"
case "${1:-}" in check|-y|"") TARGET="${LATEST}" ;; *) TARGET="$1" ;; esac
git rev-parse -q --verify "refs/tags/${TARGET}" >/dev/null || { echo "ERROR: no release tag ${TARGET}"; exit 1; }

CURRENT_COMMIT="$(git rev-parse HEAD)"
CURRENT="$(git describe --tags --exact-match HEAD 2>/dev/null || git rev-parse --short HEAD)"
echo "Installed: ${CURRENT}   Latest release: ${LATEST}   Target: ${TARGET}"
if [ "$(git rev-parse "${TARGET}^{commit}")" = "${CURRENT_COMMIT}" ]; then echo "dockhand-mcp is already on ${TARGET}."; exit 0; fi

echo "Changes ${CURRENT} -> ${TARGET}:"; git log --oneline "HEAD..${TARGET}" | head -30
git diff --stat HEAD "${TARGET}" | tail -15
[ "${1:-}" = "check" ] && exit 0
if [ "${1:-}" != "-y" ]; then read -rp "Install ${TARGET}? [y/N] " a; [ "${a}" = "y" ] || exit 0; fi

# Grab the two secrets from the running container before anything changes
for v in DOCKHAND_API_TOKEN MCP_AUTH_TOKEN; do
    val="$(docker inspect dockhand-mcp --format "{{range .Config.Env}}{{println .}}{{end}}" | sed -n "s/^${v}=//p")"
    [ -n "${val}" ] || { echo "ERROR: ${v} not found on running dockhand-mcp container"; exit 1; }
    export "${v}=${val}"
done

ROLLBACK="dockhand-mcp:rollback-${CURRENT}-${TS}"
docker tag dockhand-mcp:local "${ROLLBACK}"
echo "Current image tagged as ${ROLLBACK}"

git -c advice.detachedHead=false checkout -q "${TARGET}"
echo "Building dockhand-mcp:local (${TARGET}) ..."
docker build -q -t dockhand-mcp:local "${REPO}"
docker tag dockhand-mcp:local "dockhand-mcp:${TARGET}"

# Recreate from the Dockhand stack files (tokens come from the exported env above)
cd "${STACK}"
docker compose -p dockhand-mcp -f compose.yaml --env-file .env up -d --force-recreate

sleep 5
if docker logs dockhand-mcp 2>&1 | tail -20 | grep -q "Connected to Dockhand successfully"; then
    echo "dockhand-mcp ${TARGET} installed and connected. Restart Claude Desktop to load any new tools."
else
    echo "WARNING: no successful Dockhand connection in logs. Rollback:"
    echo "  docker tag ${ROLLBACK} dockhand-mcp:local"
    echo "  then in Dockhand: Stacks -> dockhand-mcp -> Redeploy (re-injects the secret tokens)"
    exit 1
fi
