# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load
ZSH_THEME="robbyrussell"

# Plugins to load
plugins=(git)

# Load Oh My Zsh
source $ZSH/oh-my-zsh.sh

# User configuration
export LANG=en_GB.UTF-8
alias cls='clear'
alias h='fc -il 1'

[[ $- != *i* ]] && return

export CMD_LOG_DIR="$HOME/.cmd_logs"
mkdir -p "$CMD_LOG_DIR"
LOG_DATE=$(date +%F)
export CMD_LOG_FILE="$CMD_LOG_DIR/zsh_session_$LOG_DATE.log"

exec 3>&1 4>&2

exec 1> >(tee -a "$CMD_LOG_FILE") \
     2> >(tee -a "$CMD_LOG_FILE" >&2)

autoload -Uz add-zsh-hook

log_command() {
  local ts=$(date '+%Y-%m-%d %H:%M:%S')
  local cmd="${1%%$'\n'}"
  [[ -n "$cmd" ]] || return
  echo "\n[$ts] >>> $cmd" >> "$CMD_LOG_FILE"
  logger -t zsh-cmd "[$ts] $USER@$(hostname): $cmd"
}
add-zsh-hook zshaddhistory log_command

disable_logging() {
  exec >&3 2>&4
}

enable_logging() {
  exec 1> >(tee -a "$CMD_LOG_FILE") \
       2> >(tee -a "$CMD_LOG_FILE" >&2)
}

nano() {
  disable_logging
  command nano "$@"
  enable_logging
}

_clean_log_output() {
  sed -u -r 's/\x1B(\[[0-9;?]*[ -/]*[@-~]|\][^\a]*\a)//g' "$1" \
    | tr -d '\000-\011\013\014\016-\037'
}


zlog() {
  local tty=$(tty)
  _clean_log_output "$CMD_LOG_FILE" | less -R > "$tty"
}

zlogtail() {
  _clean_log_output "$CMD_LOG_FILE" | tail -n "${1:-20}"
}

logwrap() {
  local cmd_name="$1"; shift
  local logfile="$CMD_LOG_DIR/${cmd_name}_$(date +%F_%H-%M-%S).log"
  script -q -f "$logfile" "$cmd_name" "$@"
}
