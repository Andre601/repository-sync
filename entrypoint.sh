#!/bin/bash

TEMP_CLONE="temp_repo"

if [ -z "$EMAIL" ]; then
  echo "EMAIL enviroment is missing!"
  exit 1
fi

if [ -z "$USER" ]; then
  echo "USER enviroment is missing!"
  exit 1
fi

if [ -z "$SRC_OWNER" ]; then
  echo "OWNER enviroment is missing! Cannot continue."
  exit 1
fi

if [ -z "$SRC_REPO" ]; then
  echo "SRC_REPO enviroment is missing! Cannot continue."
  exit 1
fi

if [ -z "$SRC_FOLDER" ]; then
  echo "SRC_FOLDER enviroment is missing! Default to no folder."
  SRC_FOLDER='.'
fi

if [ -z "$TARGET_OWNER" ]; then
  echo "TARGET_OWNER enviroment is missing! Cannot continue."
  exit 1
fi

if [ -z "$TARGET_REPO" ]; then
  echo "TARGET_REPO enviroment is missing! Cannot continue."
  exit 1
fi

if [ -z "$TARGET_FOLDER" ]; then
  echo "TARGET_FOLDER enviroment is missing! Defaulting to no folder."
  TARGET_FOLDER='.'
fi

if [ ! -z "$EXCLUDE" ]; then
  SKIP=(`echo $EXCLUDE | sed s/,/\ /g`)
else
  SKIP=
fi

if [ -z "$PUSH_MESSAGE" ]; then
  echo "PUSH_MESSAGE enviroment is missing! Defaulting to 'Syncing repositories'"
  PUSH_MESSAGE='Syncing repositories'
fi

mkdir $TEMP_CLONE
cd $TEMP_CLONE
git init
git config user.name $USER
git config user.email $EMAIL
git pull https://${PAT}@github.com/$SRC_OWNER/$SRC_REPO.git
cd ..

for i in $(fin $SRC_FOLDER -maxdepth 1 -type f -execdir basename '{}' ';'); do
    echo $i
    if [[ ! " ${SKIP_DOC[@]} " =~ " ${i} " ]]; then
        cp $SRC_FOLDER/$i $TEMP_CLONE
    else
        echo "Exclude $i from Sync."
    fi
done

echo "Pushing changes"
cd $TEMP_CLONE

if [ ! -z "$TARGET_FOLDER" ]; then
  cd $TARGET_FOLDER
fi

git add .
git commit -m "$PUSH_MESSAGE"
git push --set-upstream https://${PAT}@github.com/$TARGET_OWNER/$TARGET_REPO.git master
