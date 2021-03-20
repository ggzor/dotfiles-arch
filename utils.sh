# Utilities for other scripts

set -euo pipefail

# Usage:
# link_same TARGET LINK_NAME
#
# Create a link to TARGET only if LINK_NAME does not exist
# if LINK_NAME exists and links to TARGET, then do nothing
# otherwise, fail
link_same() {
  mkdir -p $(dirname "$2")
  (ln -sT "$1" "$2" &> /dev/null && echo "Linked $2 -> $1") \
   || ([ "$(readlink "$2")" = "$1" ] && echo "Already linked $2") \
   || (echo -e "\033[0;31mUnable to link $2 -> $1\033[0m" && false)
}

# Usage:
# link_same_files SOURCE_DIR TARGET_DIR
#
# Similar to link_same, but links each file inside of TARGET
link_same_files() {
  for f in $(ls "$1"); do
    link_same "$1/$f" "$2/$f"
  done
}

# Usage
# link_same_single SOURCE_DIR FILENAME TARGET_DIR
#
# Links the file with the semantics of link_same and creates
# the directory if not exists
link_same_single() {
  link_same "$1/$2" "$3/$2"
}

