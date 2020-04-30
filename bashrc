# .bashrc
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# git auto completion
if [ -f ~/.git-completion.bash ]; then
    . ~/.git-completion.bash
fi

# User specific aliases and functions
alias grep='grep --color'
alias ll='ls -lGha'
alias remotesshkey="cat ~/.ssh/id_rsa.pub | ssh user@hostname 'cat >> .ssh/authorized_keys'"
alias rundocker="docker run -i -t ubuntu /bin/bash"
alias runboot2docker="boot2docker up"
alias hangout="open http://g.co/hangout"
alias present="open http://g.co/present"
alias upgradeYarn="curl -o- -L https://yarnpkg.com/install.sh | bash -s -- --version [version]"

## Bigstock docker aliases
alias runaws="docker run -d --dns 10.100.1.5 --name=aws -e ENV=\"dev\" -e DATA_PATH=\"/tmp/bigstock\" -e LOGS_PATH=\"/tmp\" -p 80:80 -v $(pwd):/usr/share/nginx/bigstock:cached php-aws"
alias buildaws="docker build -t php-aws ."
alias bashaws="docker exec -it aws /bin/bash"

## Network Commands
alias diggit="dig" #provides network level shit brah
alias check_network_connectivity="nc -v <url> <port>"

## Increase limit of open files to prevent studio issues
# ulimit -n 200000
# ulimit -u 2048

# Database Servers
alias stopmariadb="launchctl unload -w ~/Library/LaunchAgents/homebrew.mxcl.mysql.plist"
alias startmariadb="launchctl load -w ~/Library/LaunchAgents/homebrew.mxcl.mysql.plist"

# Rabbit MQ
alias startrabbit="brew services start rabbitmq"
alias stoprabbit="brew services stop rabbitmp"


# USER DEFINED FUNCTIONS #
dockerhint() {
    echo "run a docker image: docker run --dns 10.100.1.5 -d --name=setup -p 8080:80 -v /Users/jweaver/projects/bigstock:/usr/share/nginx/bigstock centos-base"
    echo "build an image: docker build -t centos-base ."
    echo "run image and execute bash: docker run -it --rm -v $(pwd):/bigstock -p 8080:8080 php-aws /bin/bash"
    echo "connect to bash on image:  docker exec -i -t my-apache-php-app /bin/bash"
}


# Will print the current repository branch for HG or GIT #
print_branch_name() {
    if [ -z "$1" ]
    then
        curdir=`pwd`
    else
        curdir=$1
    fi
    
    if [ -d "$curdir/.git" ]
    then
        echo -n " Current Branch:"
        git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1/'
    fi
    # Recurse upwards
    if [ "$curdir" == '/' ]
    then
        return 1
    else
        print_branch_name `dirname "$curdir"`
    fi
}

# search <filetype> <string>
function search() {
    find . -name *.$1 | xargs grep -s "$2";
}

branch_color()  {
    git rev-parse 2>/dev/null;
    if [ $? -eq 0 ]; then
        modifier=`git status | grep clean | wc -l | tr -d ' '`
        color=`expr 31 + $modifier`
        echo $color
    fi
}


# CUSTOM PROMPTS 
#PS1="\[\033[0;33m\][\h]\[\033[32m\][\w]\[\033[0m\]\[\033[\[\033[0;33m\]\[\033[0;\$(branch_color)m\]\$(print_branch_name)\n\[\033[1;36m\]\u\[\033[1;33m\]-> \[\033[0m\]"
#PS1="\n\[\033[0;33m\][\h]\[\033[32m\][\w]\[\033[0m\]\[\033[\[\033[0;33m\]\$(print_branch_name)\n\[\033[1;36m\]\u\[\033[1;33m\]-> \[\033[0m\]"
#PS1="\n\[\033[1;33m\]\u\[\033[1;37m\] \[\033[0;36m\]`date`\n\[\033[0m\][\[\033[1;33m\]\w\[\033[0m\]] "

# Custom bash prompt via kirsle.net/wizards/ps1.html
#PS1="\[$(tput bold)\]\[$(tput setaf 2)\]\u@\h: \[$(tput setaf 6)\][\w]\[$(tput sgr0)\]"
#PS1="\[$(tput bold)\]\[$(tput setaf 2)\]\u@\h:\[$(tput setaf 3)\][\w]\[$(tput setaf 4)\] $ \[$(tput sgr0)\]"

function prompt_command {
    local max_pwd_length=30
    local max_screen_pwd_length=18
    local pwd_length=$(echo -n $PWD | wc -c | tr -d " ")
    if [ $pwd_length -gt $max_pwd_length ]
    then
        shortPWD="--$(echo -n $PWD | sed -e "s/.*\(.\{$max_pwd_length\}\)/\1/")"
    else
        shortPWD="$(echo -n $PWD)"
    fi
    if [ $pwd_length -gt $max_screen_pwd_length ]
    then
        screenPWD="<$(echo -n $PWD | sed -e "s/.*\(.\{$max_screen_pwd_length\}\)/\1/")"
    else
        screenPWD="$(echo -n $PWD)"
    fi

    # If this is an xterm set the title to user@host:dir
    case "$TERM" in
    xterm*|rxvt*)
        echo -ne "\033]0;${USER}@${HOSTNAME}: ${PWD}\007"
        ;;
    screen)
        echo -ne "^[k$screenPWD^[\\"
        ;;
    *)
        ;;
    esac

    # Get the git branch of this dir
    gitbranch="$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"
}
# PROMPT_COMMAND=prompt_command

# PS1='\[\033[01;93m\]${gitbranch}:\[\033[01;96m\]${shortPWD}\[\033[00m\]\$ '