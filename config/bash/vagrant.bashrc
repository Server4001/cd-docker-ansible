# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
alias ll="ls -lah"
alias gst="git status"
alias gb="git branch"
alias gpo="git push origin"

docker_rm_containers() {
    docker rm $(docker ps -aq)
}

