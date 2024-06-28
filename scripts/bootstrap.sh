#!/usr/bin/env bash

printf "Installing asdf\n"
printf "asdf manages versions of language runtimes and other tools.\n"
printf "Documentation: https://asdf-vm.com/guide/getting-started.html\n"

if ! command -v asdf &> /dev/null; then
    git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.14.0
if [[ "$SHELL" == *"bash"* ]]; then
    echo ". $(brew --prefix asdf)/libexec/asdf.sh" >> "${HOME}/.bashrc"
    source "${HOME}/.bashrc"
elif [[ "$SHELL" == *"/zsh"* ]]; then
    echo ". $(brew --prefix asdf)/libexec/asdf.sh" >> "${HOME}/.zshrc"
    source "${HOME}/.zshrc"
else
    echo "Shell is not Bash or ZSH. Detected: $SHELL"
fi
fi

printf "Installing just\n"
printf "Just is a handy way to save and run project-specific commands.\n"
printf "Documentation: https://github.com/casey/just#readme\n"

asdf plugin add just https://github.com/olofvndrhr/asdf-just.git
asdf install just
