#!/bin/bash
set -u

if [ $# -ne 2 ]
then
	echo "Usage: $0 <new_tag> <ignore_branch>"
	exit
fi

readonly new_tag=$1
readonly ignore_branch=$2

readonly current_branch=$(git branch --show-current)
readonly old_tag=$(git tag --sort=-creatordate --merged=${current_branch} | head -n 1)

set -x
tmpfile=$(mktemp)
set +x

echo "## New Features" >> ${tmpfile}
git log --pretty=oneline ${old_tag}...HEAD \
  | awk '!_[$0]++' \
  | awk '{$1=""}1' \
  | awk '{print "-"$0}' \
  | grep -e 'feat' \
  >> ${tmpfile}
echo >> ${tmpfile}
echo "## Improvement" >> ${tmpfile}
git log --pretty=oneline ${old_tag}...HEAD \
  | awk '!_[$0]++' \
  | awk '{$1=""}1' \
  | awk '{print "-"$0}' \
  | grep -e 'improvement' \
  >> ${tmpfile}
echo >> ${tmpfile}
echo "## Bug Fixes" >> $tmpfile
git log --pretty=oneline ${old_tag}...HEAD \
  | awk '!_[$0]++' \
  | awk '{$1=""}1' \
  | awk '{print "-"$0}' \
  | grep -e 'fix' \
  >> ${tmpfile}
echo >> ${tmpfile}
echo "## Etc" >> ${tmpfile}
git log --pretty=oneline ${old_tag}...HEAD \
  | awk '!_[$0]++' \
  | awk '{$1=""}1' \
  | awk '{print "-"$0}' \
  | grep -v -e 'fix' -e 'feat' -e 'improvement' -e 'chore' \
  >> ${tmpfile}
echo >> ${tmpfile}

echo "====== Release Note ======"

cat "${tmpfile}"
echo "==================
"
echo "tag: ${old_tag} ==> ${new_tag}"
echo "branch: ${current_branch}"

read -r -p "リリースしますか? [y/N] " response
case "$response" in
  [yY][eE][sS]|[yY])
    set -exuo pipefail
    echo "${new_tag}" > VERSION
    git add VERSION
    git commit -m "chore(release): ${new_tag}"
    git tag ${new_tag}
    git push origin ${new_tag}
    gh release create ${new_tag} -F ${tmpfile}
    rm ${tmpfile}
    ;;
  *)
    echo "exit"
    rm ${tmpfile}
    exit 1
    ;;
esac

