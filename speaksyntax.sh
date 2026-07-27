# Warn command syntax for GKrellM CPU temp warning

# sh is a command that invokes the shell
# the -c is an option passed to sh. It tells the shell to execute the command(s) provided
#   within the double quotes as a single string
# echo is a command that displays its arguments to the standard output
# $s is a shell variable that will insert the current CPU temp
# The pipe symbol | takes the standard output of the command on its left and redirects it
#   as the standard input to the command on its right
# espeak is a text-to-speech synthesizer. It takes text as input and converts it into
#   spoken audio
# -v en-gb option specifies the British English voice to be used
# -s 150 option sets the speaking speed to 150 words per minute
# -g 15 option sets the word gap or pause between words to 15 milliseconds

sh -c "echo warning CPU is at $s degrees | espeak -v en-gb -s 150 -g 15"
