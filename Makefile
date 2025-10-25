DOCKER_USERNAME ?= tomhoover
APPLICATION_NAME ?= gitolite
GIT_HASH ?= $(shell git log --format="%h" -n 1)

ifeq ($(shell command -v podman 2> /dev/null),)
	CMD=docker
else
	CMD=podman
endif

build:
	$(CMD) build --tag ${DOCKER_USERNAME}/${APPLICATION_NAME} .

tag:
	$(CMD) tag  ${DOCKER_USERNAME}/${APPLICATION_NAME} ${DOCKER_USERNAME}/${APPLICATION_NAME}:${GIT_HASH}

init:
	# docker run --rm -e SSH_KEY="$(cat ~/.ssh/id_rsa.pub)" -e SSH_KEY_NAME="$(whoami)" -v gitolite-sshkeys:/etc/ssh/keys -v gitolite-git:/var/lib/git jgiannuzzi/gitolite true
	$(CMD) run --rm -e SSH_KEY="$(shell cat ~/.ssh/id_rsa_ariel.pub)" -e SSH_KEY_NAME="tom@ariel" -v ~/data/docker/gitolite-sshkeys:/etc/ssh/keys -v ~/data/docker/gitolite-git:/var/lib/git ${DOCKER_USERNAME}/${APPLICATION_NAME} true

start:
	# docker run -d --name gitolite -p 22:22 -v gitolite-sshkeys:/etc/ssh/keys -v gitolite-git:/var/lib/git jgiannuzzi/gitolite
	$(CMD) run -d --name ${APPLICATION_NAME} -p 2222:22 -v ~/data/docker/gitolite-sshkeys:/etc/ssh/keys -v ~/data/docker/gitolite-git:/var/lib/git ${DOCKER_USERNAME}/${APPLICATION_NAME}

stop:
	$(CMD) stop ${APPLICATION_NAME}

kill: stop
	$(CMD) container rm ${APPLICATION_NAME}
