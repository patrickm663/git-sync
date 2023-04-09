#! bin/bash
# Author: Patrick Moehrke
# Licence: BSD 3

pull_repo () {
  echo -e "Repo: " $(echo $1 | sed "s/.git//") 
  read -n 1 -p "Would you like to check for updates? [y/n] " confirmation;
  if [ "$confirmation" = "y" ]
  then
    echo -e " "
    cd $1
    cd ../
    STATUS=$(git remote update; git status -uno | grep -o "Your branch is up to date")
    if [ -z "$STATUS" ]
    then
      read -n 1 -p "Would you like to apply updates? [y/n] " confirmation;
      if [ "$confirmation" = "y" ]
      then
	echo -e " "
	git pull
      fi
    else
      echo -e $STATUS
    fi
  fi
  echo -e " "
  cd ~/
}

main () {
  cd ~/
  for repo in $(find -name ".git")
  do
    pull_repo $repo
  done
}

main
