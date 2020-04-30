# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# Set up the line separator between terminal commands 
if [ -f ~/.bash_ps1 ]; then
	. ~/.bash_ps1
fi

HISTSIZE=10000
export HISTSIZE

# User specific environment and startup programs
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

# Setting PATH for Python 3.8
# The original version is saved in .bash_profile.pysave
PATH="/Library/Frameworks/Python.framework/Versions/3.8/bin:${PATH}"
export PATH
