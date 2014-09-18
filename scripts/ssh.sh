#!/usr/bin/env bash

[[ -z $1 ]] && { echo "You must provider your github username!"; exit 1; }
[[ -z $2 ]] && { echo "You must provider your github password!"; exit 1; }

# generate an ssh key-pair
ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa

# copy the public key to a variable
pub_key=`cat ~/.ssh/id_rsa.pub`

# get the current date
now=`date +'%m/%d/%Y'`;

# use github's api to add an ssh key
curl -i -u "$1:$2" -d "{\"title\": \"OracleLogueVM - $now\",\"key\": \"$pub_key\"}" https://api.github.com/user/keys
 
# test that it worked
ssh -T git@github.com