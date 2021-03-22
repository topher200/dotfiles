#!/bin/bash
# Stolen from: https://github.com/jessfraz/dotfiles/blob/master/test.sh

set -e
set -o pipefail

ERRORS=()

# find all executables and run `shellcheck` on them
# define excludes here:
for f in $(find . -type f \
    -not -iwholename '*.git*' \
    -not -iwholename './tpm*' \
    -not -iwholename "./oh-my-zsh-custom*" \
    -not -iwholename "./nanorc-folder*" \
    -not -iwholename "./powerline*" \
    -not -iwholename "./xinitrc*" \
    -not -iwholename "./fzf*" | sort -u); do


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
    printf '%s\n' "${ERRORS[@]}"
    exit 1
fi

