#!/usr/bin/env zsh

rm --force --recursive .git

git init --initial-branch main
git add .
git commit --message 'Repository Reset'
git remote add origin git@github.com:asininemonkey/nixos.git
git push --force --mirror
git push --set-upstream origin main
