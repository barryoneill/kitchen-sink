
# ------------------- colors -------------------
YLOBRN='\033[01;33;40m'
WHTBRN='\033[01;37;40m'
REDBRN='\033[00;31;40m'
REDBLK='\033[00;31;40m'
PPLBLK='\033[01;35;40m'
WHTBLK='\033[01;37;40m'
CYNBLK='\033[01;32;40m'
NONE='\033[00m'
E='\['
R='\]'

# ------------------- default prompt -------------------
PS1=${E}${YLOBRN}'\# '${R}${E}${REDBRN}' \w '${REDBLK}${CYNBLK}${R}' \d \t '${E}${NONE}'   \n'${E}${PPLBLK}${R}'docker-ksink '${E}${NONE}${R}' '#' '
PS1X=']2; \u on \h in \w '

umask 077

# ------------------- shell options -------------------
HISTFILESIZE=200
HISTSIZE=400
HISTCONTROL=ignoreboth
EDITOR='vim'
VISUAL=${EDITOR}
PAGER='less'
set -o ignoreeof



