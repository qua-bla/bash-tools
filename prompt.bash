#!/bin/bash

# Reset
Color_Off='\x01\e[0m\x02'       # Text Reset

# Regular Colors
Black='\x01\e[0;30m\x02'        # Black
Red='\x01\e[0;31m\x02'          # Red
Green='\x01\e[0;32m\x02'        # Green
Yellow='\x01\e[0;33m\x02'       # Yellow
Blue='\x01\e[0;34m\x02'         # Blue
Purple='\x01\e[0;35m\x02'       # Purple
Cyan='\x01\e[0;36m\x02'         # Cyan
White='\x01\e[0;37m\x02'        # White


# Bold
BoldBlack='\x01\e[1;30m\x02'       # Black
BoldRed='\x01\e[1;31m\x02'         # Red
BoldGreen='\x01\e[1;32m\x02'       # Green
BoldYellow='\x01\e[1;33m\x02'      # Yellow
BoldBlue='\x01\e[1;34m\x02'        # Blue
BoldPurple='\x01\e[1;35m\x02'      # Purple
BoldCyan='\x01\e[1;36m\x02'        # Cyan
BoldWhite='\x01\e[1;37m\x02'       # White

# Underline
UnderBlack='\x01\e[4;30m\x02'       # Black
UnderRed='\x01\e[4;31m\x02'         # Red
UnderGreen='\x01\e[4;32m\x02'       # Green
UnderYellow='\x01\e[4;33m\x02'      # Yellow
UnderBlue='\x01\e[4;34m\x02'        # Blue
UnderPurple='\x01\e[4;35m\x02'      # Purple
UnderCyan='\x01\e[4;36m\x02'        # Cyan
UnderWhite='\x01\e[4;37m\x02'       # White

# Background
BgBlack='\x01\e[40m\x02'       # Black
BgRed='\x01\e[41m\x02'         # Red
BgGreen='\x01\e[42m\x02'       # Green
BgYellow='\x01\e[43m\x02'      # Yellow
BgBlue='\x01\e[44m\x02'        # Blue
BgPurple='\x01\e[45m\x02'      # Purple
BgCyan='\x01\e[46m\x02'        # Cyan
BgWhite='\x01\e[47m\x02'       # White


function save_exit_status {
    export LAST_EXIT_STATUS=$?
    echo saved ${LAST_EXIT_STATUS}
}

function exit_status {
    ERRNO=$?
    
    if [ "${ERRNO}" = "0" ]; then
        echo -e "${Green}✔${Color_Off}"
    elif [ "${ERRNO}" = "127" ]; then
        echo -e "${Red}❓${Color_Off}"
    elif [ "${ERRNO}" = "130" ]; then
        echo -e "${Yellow}✘${Color_Off}"
    else
        echo -e "${1}${Red}✘${Color_Off} ${BgRed}${ERRNO}${Color_Off}${2}"
    fi
}

function tmux_status {
    if [ "${TMUX_PANE}" = "" ]; then
        echo ""
    else
        echo -e "${1}${Yellow}${3}${TMUX_PANE}${4}${Color_Off}${2}"
    fi
}

function screen_status {
    if [[ "${TERM}" = "screen" && ! ${TMUX_PANE} ]]; then
        echo -e "${1}${Yellow}${3}${TERM}${4}${Color_Off}${2}"
    fi
}

function ssh_status {
    if [ "${SSH_TTY}" = "" ];
    then
        echo "⚙"
    else
        echo -e "${Yellow}☎${Color_Off}"
    fi
}

function BoldWhite {
    echo -e "${BoldWhite}"
}

function BoldBlue {
    echo -e "${BoldBlue}"
}


function NoColor {
    echo -e "${Color_Off}"
}

function color_str {
    Str=$1
    SelColor=`echo "$1" | shasum | head -c 1`

    if [ "${SelColor}" = "1" ]; then
        ColorStr="${BoldBlack}"
    elif [ "${SelColor}" = "2" ]; then
        ColorStr="${BoldRed}"
    elif [ "${SelColor}" = "3" ]; then
        ColorStr="${BoldGreen}"
    elif [ "${SelColor}" = "4" ]; then
        ColorStr="${BgYellow}"
    elif [ "${SelColor}" = "5" ]; then
        ColorStr="${BoldYellow}"
    elif [ "${SelColor}" = "6" ]; then
        ColorStr="${BoldPurple}"
    elif [ "${SelColor}" = "7" ]; then
        ColorStr="${BoldCyan}"
    elif [ "${SelColor}" = "8" ]; then
        ColorStr="${BoldWhite}"
    elif [ "${SelColor}" = "9" ]; then
        ColorStr="${BgBlack}"
    elif [ "${SelColor}" = "0" ]; then
        ColorStr="${BgRed}"
    elif [ "${SelColor}" = "a" ]; then
        ColorStr="${BgGreen}"
    elif [ "${SelColor}" = "b" ]; then
        ColorStr="${BgBlue}"
    elif [ "${SelColor}" = "c" ]; then
        ColorStr="${BoldBlue}"
    elif [ "${SelColor}" = "d" ]; then
        ColorStr="${BgPurple}"
    elif [ "${SelColor}" = "e" ]; then
        ColorStr="${BgCyan}"
    elif [ "${SelColor}" = "f" ]; then
        ColorStr="${BgWhite}"
    else
        ColorStr="${UnderWhite}"
    fi
 
    echo -e "${ColorStr}${Str}${Color_Off}"
}

function host_name {
    color_str `hostname`
}

export colored_host_name=`host_name`

PS1='$(exit_status)$(tmux_status " " "" "(tmux" ")")$(screen_status " " "" "(" ")") ⌂$(BoldWhite)\u$(NoColor) $(ssh_status)${colored_host_name}: \w\n$(BoldBlue)\W $(BoldWhite)\$$(NoColor) '

PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD/$HOME/\~}\007"'

