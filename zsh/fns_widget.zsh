# fns Ctrl-F zle widget (zsh only)
#
# Binds Ctrl-F to the `fns` picker so you can invoke it without typing anything.
# Selected name is appended to the current command-line buffer in place.
# This complements fns.src, which provides the underlying _fns_pick helper.
#

if [ -n "$ZSH_VERSION" ]; then
  _fns_zle() {
    local selected
    selected=$(_fns_pick)
    if [ -n "$selected" ]; then
      LBUFFER+="$selected"
    fi
    zle reset-prompt
  }
  zle -N _fns_zle
  bindkey '^f' _fns_zle
fi
