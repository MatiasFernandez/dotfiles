#!/bin/bash
#
# bootstrap installs things.

cd "$(dirname "$0")"
DOTFILES_ROOT=$(pwd -P)

set -e

echo ''

info () {
  printf "\r  [ \033[00;34m..\033[0m ] $1\n"
}

user () {
  printf "\r  [ \033[0;33m??\033[0m ] $1\n"
}

success () {
  printf "\r\033[2K  [ \033[00;32mOK\033[0m ] $1\n"
}

fail () {
  printf "\r\033[2K  [\033[0;31mFAIL\033[0m] $1\n"
  echo ''
  exit
}

setup_gitconfig () {
  if ! [ -f configs/git/gitconfig.local.symlink ]
  then
    info 'setup gitconfig'

    git_credential='cache'
    if [ "$(uname -s)" == "Darwin" ]
    then
      git_credential='osxkeychain'
    fi

    user ' - What is your github author name?'
    read -e git_authorname
    user ' - What is your github author email?'
    read -e git_authoremail

    sed -e "s/AUTHORNAME/$git_authorname/g" -e "s/AUTHOREMAIL/$git_authoremail/g" -e "s/GIT_CREDENTIAL_HELPER/$git_credential/g" configs/git/gitconfig.local.symlink.example > configs/git/gitconfig.local.symlink

    success 'gitconfig'
  fi
}


link_file () {
  local src=$1 dst=$2

  local overwrite= backup= skip=
  local action=

  if [ -f "$dst" -o -d "$dst" -o -L "$dst" ]
  then

    if [ "$overwrite_all" == "false" ] && [ "$backup_all" == "false" ] && [ "$skip_all" == "false" ]
    then

      local currentSrc="$(readlink $dst)"

      if [ "$currentSrc" == "$src" ]
      then

        skip=true;

      else

        user "File already exists: $dst ($(basename "$src")), what do you want to do?\n\
        [s]kip, [S]kip all, [o]verwrite, [O]verwrite all, [b]ackup, [B]ackup all?"
        read -n 1 action

        case "$action" in
          o )
            overwrite=true;;
          O )
            overwrite_all=true;;
          b )
            backup=true;;
          B )
            backup_all=true;;
          s )
            skip=true;;
          S )
            skip_all=true;;
          * )
            ;;
        esac

      fi

    fi

    overwrite=${overwrite:-$overwrite_all}
    backup=${backup:-$backup_all}
    skip=${skip:-$skip_all}

    if [ "$overwrite" == "true" ]
    then
      rm -rf "$dst"
      success "removed $dst"
    fi

    if [ "$backup" == "true" ]
    then
      mv "$dst" "${dst}.backup"
      success "moved $dst to ${dst}.backup"
    fi

    if [ "$skip" == "true" ]
    then
      success "skipped $src"
    fi
  fi

  if [ "$skip" != "true" ]  # "false" or empty
  then
    ln -s "$1" "$2"
    success "linked $1 to $2"
  fi
}

select_shell () {
  user 'Which shell(s) do you want to configure? [b]ash / [z]sh / [B]oth (default: b)'
  read -n 1 shell_choice
  echo ''
  case "$shell_choice" in
    z ) SETUP_BASH=false; SETUP_ZSH=true ;;
    B ) SETUP_BASH=true;  SETUP_ZSH=true ;;
    * ) SETUP_BASH=true;  SETUP_ZSH=false ;;
  esac
}

setup_antidote () {
  if brew list antidote &>/dev/null; then
    success 'antidote already installed, skipping'
    return
  fi

  info 'installing antidote'
  brew install antidote
  success 'antidote installed'
}

install_dotfiles () {
  info 'installing dotfiles'

  local overwrite_all=false backup_all=false skip_all=false

  for src in $(find -H "$DOTFILES_ROOT" -maxdepth 3 -name '*.symlink' -not -path '*.git*')
  do
    dst="$HOME/.$(basename "${src%.*}")"
    link_file "$src" "$dst"
  done

  if [ "$(uname -s)" == "Darwin" ]; then
    link_file "$DOTFILES_ROOT/configs/macos/Brewfile" "$HOME/.config/brewfile/Brewfile"
  fi

  if [ "$SETUP_BASH" == "true" ]; then
    if [ `fgrep -c "bashrc.mine" ~/.bashrc 2>/dev/null` -eq 0 ]; then
      echo "source ~/.bashrc.mine" >> ~/.bashrc
      success "Added sourcing of .bashrc.mine to .bashrc"
    else
      success "Skipped sourcing of .bashrc.mine (already present)"
    fi
  fi

  if [ "$SETUP_ZSH" == "true" ]; then
    setup_antidote
    touch ~/.zshrc
    if [ `fgrep -c "zshrc.mine" ~/.zshrc` -eq 0 ]; then
      echo "source ~/.zshrc.mine" >> ~/.zshrc
      success "Added sourcing of .zshrc.mine to .zshrc"
    else
      success "Skipped sourcing of .zshrc.mine (already present)"
    fi
  fi
}


setup_gitconfig
select_shell
install_dotfiles

echo ''
echo '  All installed!'
