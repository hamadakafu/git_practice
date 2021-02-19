#!/bin/bash
set -u

if [ $# -ne 1 ]
then
	echo "Usage: $0 <new_tag>"
	exit
fi

cd $(git rev-parse --show-toplevel)

if ! which gh >> /dev/null
then
  echo "install gh. https://github.com/cli/cli."
  exit 1
fi
readonly new_tag=$1

readonly now_branch=$(git branch --show-current)
readonly old_tag=$(git tag --sort=-creatordate --merged=${now_branch} | head -n 1)

echo "リリースノートの作成 branch: ${now_branch}"
read -r -p "$old_tag >> $new_tag? [y/N] " response
case "$response" in
  [yY][eE][sS]|[yY])
    echo "creating release note...
    "
    ;;
  *)
    echo "exit"
    exit 1
    ;;
esac

tmpfile=$(mktemp)

echo "# ${new_tag} ($(date '+%Y-%m-%d'))" >> ${tmpfile}

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

echo "---"

cat ${tmpfile}
echo "---"

read -r -p "リリースしますか? [y/N] " response
case "$response" in
  [yY][eE][sS]|[yY])
    set -exuo pipefail
    git tag ${new_tag}
    echo "${new_tag}" > VERSION
    git diff -- VERSION
    git add VERSION
    git commit -m "chore(release): ${new_tag} [skip ci]"
    git push origin ${now_branch}
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
