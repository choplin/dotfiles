#!/bin/bash
# from http://willi.am/blog/2015/02/27/dynamically-configure-your-git-email/

set -e
set -u

name=choplin
email=choplin.choplin@gmail.com

remote=$(git remote -v | awk '/\(push\)$/ {print $2}')

if [ $(echo $remote | grep 'scalar-labs') ]; then
  name="Akihiro Okuno"
  email=akihiro.okuno@scalar-labs.com
fi

echo "Configuring user.name as $name"
git config user.name "$name"

echo "Configuring user.email as $email"
git config user.email "$email"
