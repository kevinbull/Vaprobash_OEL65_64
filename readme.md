TheLogueBash
=============

This is a set of scripts to get a local development environment up and running for The Logue.

## Installation

```sh
git clone [git-repo-url] LogueVM
cd LogueVM
vagrant up
vagrant ssh
cd /vagrant/scripts
sh ssh.sh [your-github-username] [your-github-password]
sh install_thelogue.sh
```

After composer installs TheLogue's dependencies the console will prompt you for some application parameters. Get David to send you those parameters.

## Running tests
Finally, you should be able to get into the app directory, `cd thelogue`, and run the behat test suite with the following command:

`./bin/behat @ClearC2TheLogueAssetBundle/asset.feature`

The application should be running at http://thelogue.dev/. If you get errors from the test suite make sure your `hosts` file as been updated with the following line, `192.160.56.120 thelogue.dev`.