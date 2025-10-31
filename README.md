# Docker image for Gitolite

This image allows you to run a git server in a container with OpenSSH and [Gitolite](https://github.com/sitaramc/gitolite#readme).

Based on Alpine Linux.

## Quick setup

_Where `(docker|podman)` appears below, use either `docker` or `podman` (as appropriate)._

Create volumes for your SSH server host keys and for your Gitolite config and repositories:

* Docker >= 1.13 or Podman

        (docker|podman) volume create gitolite-sshkeys
        (docker|podman) volume create gitolite-git

* Docker >= 1.9 ('--name' is optional beginning with v1.13)

        docker volume create --name gitolite-sshkeys
        docker volume create --name gitolite-git

* Docker < 1.9

        docker create --name gitolite-data -v /etc/ssh/keys -v /var/lib/git tianon/true

Setup Gitolite with yourself as the administrator:

* Docker >= 1.10 or Podman

        (docker|podman) run --rm -e SSH_KEY="$(cat ~/.ssh/id_rsa.pub)" -e SSH_KEY_NAME="$(whoami)" -v gitolite-sshkeys:/etc/ssh/keys -v gitolite-git:/var/lib/git jgiannuzzi/gitolite true

* Docker == 1.9 (There is a bug in `docker run --rm` that removes volumes when removing the container)

        docker run --name gitolite-setup -e SSH_KEY="$(cat ~/.ssh/id_rsa.pub)" -e SSH_KEY_NAME="$(whoami)" -v gitolite-sshkeys:/etc/ssh/keys -v gitolite-git:/var/lib/git jgiannuzzi/gitolite true
        docker rm gitolite-setup

* Docker < 1.9

        docker run --rm -e SSH_KEY="$(cat ~/.ssh/id_rsa.pub)" -e SSH_KEY_NAME="$(whoami)" --volumes-from gitolite-data jgiannuzzi/gitolite true

Finally run your Gitolite container in the background:

* Docker >= 1.9

        docker run -d --name gitolite -p 22:22 -v gitolite-sshkeys:/etc/ssh/keys -v gitolite-git:/var/lib/git jgiannuzzi/gitolite

* Docker < 1.9

        docker run -d --name gitolite -p 22:22 --volumes-from gitolite-data jgiannuzzi/gitolite

* Podman

        podman run -d --name gitolite -p 22:22 -v gitolite-sshkeys:/etc/ssh/keys -v gitolite-git:/var/lib/git:exec jgiannuzzi/gitolite

You can then add users and repos by following the [official guide](https://github.com/sitaramc/gitolite#adding-users-and-repos).
