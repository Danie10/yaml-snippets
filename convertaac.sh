#!/bin/bash

# This script is intended for use with DaVinci Resolve Studio paid edition 
#   (free requires video codec to convert to dnxhd, which could be added to 
#   the ffmpeg lines if needed)
# It leaves the video codec as-is, but quickly converts just AAC audio to PCM codec
# It will accept multiple filenames as input so that it can run as a right-click
#   option on the file explorer
# It will also check if there are more than one audio track, and convert all audio
#   tracks from AAC to PCM (this was added after I recorded the video


# Check if ffmpeg is installed
if ! command -v ffmpeg &>/dev/null; then
    echo "Error: ffmpeg is not installed. Please install ffmpeg before running this script."
    exit 1
fi

# Check if any arguments are provided
if [ \$# -eq 0 ]; then
    echo "Error: Please provide one or more filenames as arguments."
    echo "Usage: \$0 file1.mp4 file2.mp4 ..."
    exit 1
fi

# Loop through each input file
for file in "\$@"; do
    # Check if the file exists
    if [ ! -f "\$file" ]; then
        echo "Error: File '\$file' does not exist."
        continue # Skip to the next iteration if file doesn't exist
    fi

    # Get the number of audio streams using ffmpeg
    num_audio_streams=\$(ffmpeg -i "\$file" -show_streams -count_streams a 2>&1 | tail -n 1)

    # Check for errors during ffmpeg information retrieval
    if [[ \$? -ne 0 ]]; then
        echo "Error: Failed to get information about '\$file'."
        continue
    fi

    # Define the output filename (append "PCM" to the filename and change extension to .mov)
    output_file="\${file%.*}_PCM.mov"

    # Determine the output format based on the number of audio streams
    if [[ "\$audio_streams" -eq 1 ]]; then
        # One audio stream: Convert to MOV with merged audio
        ffmpeg -i "\$file" -c:v copy -c:a pcm_s16le "\$output_file"
    else
        # Two or more audio streams: Convert to MOV without merging audio
        ffmpeg -i "\$file" -map 0:v -map 0:a? -c:v copy -acodec pcm_s16le "\$output_file"
    fi

    # Success message for each file
    echo "Audio successfully converted to PCM: \$output_file"
done
