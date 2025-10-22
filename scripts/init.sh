#!/usr/bin/env bash
sourceBase=$(dirname $SOURCE)/../
cd ${basedir:-$sourceBase}

basedir=$(pwd -P)
# cd -

# Name of the upstream repo. Example would be to use Multiverse-Core if you were forking that plugin.
UPSTREAM_NAME="PatchedFork"
# Name this whatever you want, such as upstream name + a suffix.
FORK_NAME="PatchedFork-Patched"
# URL where this fork's repository will be located at.
REPO="https://github.com/AcheronInteractive/PatchedFork"

function bashColor {
if [ $2 ]; then
	echo -e "\e[$1;$2m"
else
	echo -e "\e[$1m"
fi
}
function bashColorReset {
	echo -e "\e[m"
}

function cleanupPatches {
	cd "$1"
	for patch in *.patch; do
		gitver=$(tail -n 2 $patch | grep -ve "^$" | tail -n 1)
		diffs=$(git diff --staged $patch | grep -E "^(\+|\-)" | grep -Ev "(From [a-z0-9]{32,}|\-\-\- a|\+\+\+ b|.index|Date\: )")

		testver=$(echo "$diffs" | tail -n 2 | grep -ve "^$" | tail -n 1 | grep "$gitver")
		if [ "x$testver" != "x" ]; then
			diffs=$(echo "$diffs" | tail -n +3)
		fi

		if [ "x$diffs" == "x" ] ; then
			git reset HEAD $patch >/dev/null
			git checkout -- $patch >/dev/null
		fi
	done
}
function pushRepo {
	if [ "$(git config minecraft.push-${FORK_NAME})" == "1" ]; then
	echo "Pushing - $1 ($3) to $2"
	(
		cd "$1"
		git remote rm patched-fork-push > /dev/null 2>&1
		git remote add patched-fork-push $2 >/dev/null 2>&1
		git push patched-fork-push $3 -f
	)
	fi
}
function basedir {
	cd "$basedir"
}
function gethead {
	(
		cd "$1"
		git log -1 --oneline
	)
}
