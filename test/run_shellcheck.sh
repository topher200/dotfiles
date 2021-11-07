#!/bin/bash
# Stolen from: https://github.com/jessfraz/dotfiles/blob/master/test.sh

set -e
set -o pipefail

ERRORS=()

# find all executables and run `shellcheck` on them
# define excludes here:
for f in $(find . -type f \
    -not -iwholename '*.git*' \
    -not -iwholename './files/.oh-my-zsh/*' \
    -not -iwholename './files/.tmux/plugins/*' \
    -not -iwholename './files/bin/dropbox_uploader.sh' \
    -not -iwholename './files/bin/ftwind' \
    -not -iwholename './files/bin/vimv' \
    -not -iwholename './files/zsh-custom/*' \
    -not -iwholename './node_modules/*'\
    | sort -u); do


if file "$f" | grep --quiet shell; then
    {
        shellcheck "$f" && echo "[OK]: sucessfully linted $f"
    } || {
        # add to errors
            ERRORS+=("$f")
        }
fi
done

if [ ${#ERRORS[@]} -eq 0 ]; then
    echo "No errors, hooray"
else
    echo "These files failed shellcheck: "
    printf '  %s\n' "${ERRORS[@]}"
    exit 1
fi

