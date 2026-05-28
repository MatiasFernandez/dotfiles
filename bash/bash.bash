## @bash Print the directory of the currently sourced script
[ -n "$BASH_VERSION" ] && alias scriptwd='echo $(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)'

## @bash Reload bash shell config
function dotreload() {
  source ~/.bashrc.mine
}
