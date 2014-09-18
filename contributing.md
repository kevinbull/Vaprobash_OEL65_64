TheLogueBash
=============

This is a set of scripts to get a local development environment up and running for The Logue.

Installation
--------------

```sh
git clone [git-repo-url] LogueVM
cd LogueVM
vagrant up
vagrant ssh
cd /vagrant/scripts
sh ssh.sh [your-github-username] [your-github-password]
sh install_thelogue.sh
```