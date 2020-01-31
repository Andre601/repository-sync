#!/bin/bash

TEMP_CLONE="temp_repo"
TEMP_FILES="temp_files"

if [ -z "$EMAIL" ]; then
  echo "[ERROR] EMAIL enviroment is missing!"
  exit 1
fi

if [ -z "$USER" ]; then
  echo "[ERROR] USER enviroment is missing!"
  exit 1
fi

if [ -z "$OWNER" ]; then
  echo "[ERROR] OWNER enviroment is missing! Cannot continue."
  exit 1
fi

if [ -z "$REPO" ]; then
  echo "[ERROR] REPO enviroment is missing! Cannot continue."
  exit 1
fi

if [ -z "$SRC_FOLDER" ]; then
  echo "[INFO] SRC_FOLDER enviroment is missing! Default to no folder."
  SRC_FOLDER='.'
fi

if [ -z "$TARGET_FOLDER" ]; then
  echo "[INFO] TARGET_FOLDER enviroment is missing! Defaulting to no folder."
  TARGET_FOLDER='.'
fi

if [ ! -z "$EXCLUDE" ]; then
  SKIP=(`echo $EXCLUDE | sed s/,/\ /g`)
else
  SKIP=
fi

if [ -z "$PUSH_MESSAGE" ]; then
  echo "[INFO] PUSH_MESSAGE enviroment is missing! Defaulting to 'Syncing repositories'"
  PUSH_MESSAGE='Syncing repositories'
fi

mkdir $TEMP_CLONE
cd $TEMP_CLONE
git init
git config user.name $USER
git config user.email $EMAIL
git pull https://${PAT}@github.com/$OWNER/$REPO.git
cd ..

mkdir $TEMP_FILES

for i in $(find $SRC_FOLDER -type f -execdir basename '{}' ';'); do
    echo "[INFO] Found $i"
    if [[ ! " ${SKIP_DOC[@]} " =~ " ${i} " ]]; then
        cp $SRC_FOLDER/$i /$TEMP_FILES
    else
        echo "[INFO] Exclude $i from Sync."
    fi
done

echo *

echo "[INFO] Pushing changes"

for i in $(find $TEMP_FILES -type f); do
    echo "[INFO] Processing $i..."
    if [ ! -z "$TARGET_FOLDER" ]; then
      mv -f $i /$TEMP_CLONE/$TARGET_FOLDER
    else
      mv -f $i /$TEMP_CLONE
    fi
done

cd $TEMP_CLONE

git add .
git commit -m "$PUSH_MESSAGE"
git push --set-upstream https://${PAT}@github.com/$OWNER/$REPO.git master
