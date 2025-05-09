# shellcheck shell=bash disable=1090,1091,2154

#
# This is the personal Bash configuration for https://github.com/ingydotnet
# for use in SECursor (https://github.com/ingydotnet/secursor) sessions.
#

# Git config:
git config --global user.name "Ingy döt Net"
git config --global user.email "ingy@ingy.net"

# Set and export WORKDIR
[[ $WORKDIR ]] ||
  export WORKDIR=$PWD

# Auto save ~/.bash_history
shopt -s histappend
[[ $PROMPT_COMMAND == *history* ]] ||
  export PROMPT_COMMAND="history -a;$PROMPT_COMMAND"
export PROMPT_COMMAND="history -a"

# Set bash prompt
PS1='\w $(b=$(git rev-parse --abbrev-ref HEAD 2>/dev/null); b=${b:+$b }; printf "$b")\$ '
+p() { PS1='$ '; }
-p() { PS1=$_PS1; }

# Git shortcuts
gbr() (set -x; git branch "$@")
gcam() (set -x; git commit -am "$*")
gca() (set -x; git commit -av "$@")
gcm() (set -x; git commit -m "$*")
gc() (set -x; git commit -v "$@")
gd() (set -x; git diff "$@")
glll() (gll -10 "$@")
gll() (set -x; git log --graph --decorate --pretty=oneline --abbrev-commit "$@")
gst() (set -x; git status --ignored "$@")

ls() (command ls --color "$@")
ll() (ls -lh "$@")
la() (ls -lah "$@")

RM() (rm -fr "$@")

if [[ $WORKDIR != "$HOME" && -f $WORKDIR/.secursor/bashrc ]]; then
  source "$WORKDIR/.secursor/bashrc"
fi

MYPREFIX=$WORKDIR/.git/.ext
MYBIN=$MYPREFIX/bin
MYCACHE=$MYPREFIX/cache

# Functions to pretty-print PATH and add to path (but only once)
# shellcheck disable=2086
path() (IFS=:; printf '%s\n' $PATH)

add-path() {
  [[ $PATH == "$1":* || $PATH == *:"$1":* ]] ||
    export PATH=$1:$PATH
}

# The `ys` command is here already from SECursor:
add-path "$MYBIN"

# Install latest shellcheck:
SHELLCHECK_VERSION=v0.10.0
[[ -f $MYBIN/shellcheck ]] || (
  echo "Installing shellcheck $SHELLCHECK_VERSION"
  RM "$MYCACHE/"* &&
  file=shellcheck-$SHELLCHECK_VERSION.linux.x86_64.tar.xz
  url=https://github.com/koalaman/shellcheck
  url=$url/releases/download/$SHELLCHECK_VERSION/$file
  (
    cd "$MYCACHE" || exit
    wget -q "$url" &&
    tar -xf "$file"
  ) &&
  cp "$MYCACHE/shellcheck-$SHELLCHECK_VERSION/shellcheck" "$MYBIN/"
)

# Add stuff here quickly:
she() {
  vim "${BASH_SOURCE[0]}"
  if [[ $(command -v shellcheck) ]]; then
    shellcheck "${BASH_SOURCE[0]}" || return
  fi
  source "${BASH_SOURCE[0]}"
}

# Put this last to ensure updates during shell sessions take effect:
hash -r
