#!/bin/bash

NOW=$(date +"%Y-%m-%d")

# Use git flow to tag this release with the current date (eg. 2015-03-21)
echo "--- Creating a release..."
git flow release start $NOW
git flow release finish $NOW
echo "--- New release $NOW created."
echo

echo "--- Deploying to www.jouwmoorddinerthuis.nl ..."
git push scalingo master
echo "--- Done deploying!"

git checkout develop
echo
