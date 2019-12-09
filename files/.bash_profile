if [ -f ~/.bashrc ]; then . ~/.bashrc; fi 

# The next line updates PATH for the Google Cloud SDK.
if [ -f /Users/topher/Downloads/google-cloud-sdk/path.bash.inc ]; then
  source '/Users/topher/Downloads/google-cloud-sdk/path.bash.inc'
fi

# The next line enables shell command completion for gcloud.
if [ -f /Users/topher/Downloads/google-cloud-sdk/completion.bash.inc ]; then
  source '/Users/topher/Downloads/google-cloud-sdk/completion.bash.inc'
fi
