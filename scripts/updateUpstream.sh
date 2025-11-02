#!/usr/bin/env bash

# This is very ugly, but it works on windows. Probably works on linux.
# requires curl & jq

(
set -e
PS1="$"

git add .

module=$(git config --file .gitmodules --get-regexp '\.url$' | awk '{print $2}' | awk -F '.com/' '{print $2}')
project=$(echo $module | awk -F '/' '{print $2}')
commits=$(git diff --cached $project | awk -F ' commit ' '{print $2}' | grep -v '^$' | tr '\n' '=' | sed "s/=/.../g" | head -c -3)

upstream=$(curl -H "Accept: application/vnd.github.v3+json" https://api.github.com/repos/$module/compare/$commits | jq -r '.commits[] | "'$module'@\(.sha[:7]) \(.commit.message | split("\r\n")[0] | split("\n")[0])"')

updated=""
logsuffix=""
if [ ! -z "upstream" ]; then
    logsuffix="$logsuffix\n\n$project Changes:\n$upstream"
    updated="$project"
fi
disclaimer="Upstream has released updates that appear to apply and compile correctly"

log="${UP_LOG_PREFIX}Updated Upstream ($updated)\n\n${disclaimer}${logsuffix}"

echo -e "$log" | git commit -F -

) || exit 1
