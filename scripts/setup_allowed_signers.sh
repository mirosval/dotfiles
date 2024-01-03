#!/bin/bash

email=$(git config --get user.email)
keypath=$(git config --get user.signingkey)
key=$(cat "${keypath/#\~/$HOME}")
echo "${email} ${key}" > "${HOME}"/.ssh/allowed_signers
