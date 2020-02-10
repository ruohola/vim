if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS specific settings

    # solarized colors for coloring prompt
    tput sgr0
    BASE03=$(tput setaf 234)
    BASE02=$(tput setaf 235)
    BASE01=$(tput setaf 240)
    BASE00=$(tput setaf 241)
    BASE0=$(tput setaf 244)
    BASE1=$(tput setaf 245)
    BASE2=$(tput setaf 254)
    BASE3=$(tput setaf 230)
    YELLOW=$(tput setaf 136)
    ORANGE=$(tput setaf 166)
    RED=$(tput setaf 160)
    MAGENTA=$(tput setaf 125)
    VIOLET=$(tput setaf 61)
    BLUE=$(tput setaf 33)
    CYAN=$(tput setaf 37)
    GREEN=$(tput setaf 64)
    BOLD=$(tput bold)
    RESET=$(tput sgr0)

    # autocompletion settings
    source $(brew --prefix)/etc/bash_completion 2> /dev/null

    alias vim='block_cursor && mvim -v'
    alias vimdiff='block_cursor && mvimdiff -v'

    # fzf config
    fzf_exclude='.git,Library,Applications,Qt,.DS_Store,.Trash,.temp,__pycache__,venv,.pyenv,node_modules'

    [ -f ~/.fzf.bash ] && source ~/.fzf.bash

    # remap cd to dir from ALT-C to CTRL-F
    bind '"\C-f": "\C-x\C-addi`__fzf_cd__`\C-x\C-e\C-x\C-r\C-m"'

    # open file from fzf in vim
    bind '"\C-v": "vim \C-t\C-m"'

    # -g is the opposite of --exclude, that's why the ! on the first one
    export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --no-ignore -g "!{$fzf_exclude}" 2> /dev/null'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_ALT_C_COMMAND='fd -t d --hidden --no-ignore --exclude "{$fzf_exclude}" .'

    export PATH="/Library/Frameworks/Python.framework/Versions/3.8/bin:${PATH}"
else
    alias vim='block_cursor && vim'
    alias vimdiff='block_cursor && vim'
fi


# function to show git branch on the prompt, last -e flag add one space to the end
parse_git_branch () {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/(\1)/' -e 's/$/ /'
}

# make prompt looks like this: path/to/dir (branch_if_on_git_repo) $
# export PS1="\w \$(parse_git_branch)\$ "
export PS1="\[$CYAN\]\w \[$MAGENTA\]\$(parse_git_branch)\[$CYAN\]\$ \[$RESET\]"  # solarized colored prompt
PROMPT_DIRTRIM=3  # show only last 3 dirs in prompt

export EDITOR=vim  # vim as $EDITOR

export CLICOLOR=1  # enable syntax highlighting

# needed for something to not break, don't remove
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# bash history gets written immediately
shopt -s histappend
PROMPT_COMMAND='history -a;history -n'

# unlimited bash history
HISTSIZE= 
HISTFILESIZE=

# ** expands to any number of directories
shopt -s globstar

# FIXME:
# gives this error when running LeaderF C extionsion install.sh
# /Users/eero/.bash_profile: line 61: bind: warning: line editing not enabled
bind "TAB:menu-complete"
bind "set show-all-if-ambiguous on"
bind "set menu-complete-display-prefix on"

# Changes to a block cursor when called, used to make vim always start with a block cursor
block_cursor () {
    echo -e -n "\x1b[\x32 q"
}

alias fg='block_cursor && fg'
alias vbrc='vim ~/.bash_profile && source ~/.bash_profile'
alias sbrc='source ~/.bash_profile'
alias virc='vim ~/.vim/.ideavimrc'
alias vvrc='vim ~/.vim/vimrc'
alias vset='vim ~/dotfiles/setup.sh'

alias ranger='block_cursor && ranger'

alias lsa='ls -a'
alias lsla='ls -la'
alias ls1='ls -1'
alias lsa1='ls -a1'

alias gs='git status'
alias ga='git add'
alias gaa='git add .'
alias gcl='git clone'
alias gc='block_cursor && git commit'
alias gcm='git commit -m'
alias gca='block_cursor && git commit --amend'
alias gcan='block_cursor && git commit --amend --no-edit'
alias gcae='block_cursor && git commit --allow-empty'
alias gcaem='block_cursor && git commit --allow-empty -m'
alias gpl='git pull --rebase'
alias gps='git push'
alias gpsf='git push -f'
alias gpsu='git push -u'
alias gsu='git branch --set-upstream-to=origin/`git symbolic-ref --short HEAD`'
alias gds='git diff --staged'
alias gdh='git diff HEAD'
alias gl='git log --graph --date-order'
alias glf='git log --graph --date-order --name-status'
alias gls='git log --graph --date-order --numstat'
alias gb='git checkout -b'
alias gco='git checkout'

alias bkandi='
cd ~/Documents/yliopisto/kandi
pdflatex kandi.tex
bibtex kandi
pdflatex kandi.tex
pdflatex kandi.tex
rm kandi.aux
rm kandi.bbl
rm kandi.blg
rm kandi.log
rm kandi.toc'

# alises for skole dev
alias killskole='
find . -path "*/migrations/*.py" -not -name "__init__.py" -delete
find . -path "*/migrations/*.pyc" -delete
docker container rm -f backend
docker container rm -f db
docker volume rm skole_postgres_data
docker-compose run --rm backend sh -c "
    python src/manage.py wait_for_db &&
    python src/manage.py makemigrations &&
    python src/manage.py migrate &&
    python src/manage.py loaddata test-data.yaml
"
'
alias formatskole='
docker-compose run --no-deps --rm backend sh -c "
    autoflake -ir --remove-all-unused-imports --exclude __init__.py src &&
    isort -rc src &&
    black --exclude migrations/* src
"
'
alias allskole='
docker-compose run --rm backend sh -c "
    autoflake -ir --remove-all-unused-imports --exclude __init__.py src &&
    isort -rc src &&
    black --exclude migrations/* src
    mypy src
    pytest --cov-report html --cov=src src/tests/
"
'
alias mypyskole='docker-compose run --no-deps --rm backend sh -c "mypy src"'
alias testskole='docker-compose run --rm backend pytest --cov-report html --cov=src src/tests/'
alias runskole='docker-compose run --rm backend'


alias act='source venv/bin/activate'

alias lg='lazygit'

alias clamshell='sudo pmset -a disablesleep 1'
alias noclamshell='sudo pmset -a disablesleep 0'

export PATH="$HOME/.cargo/bin:${PATH}"
export PATH="$HOME/dotfiles/bash/exported:${PATH}"
