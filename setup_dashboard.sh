#/bin/bash
# Script to assist with first-time setup of the Dashboard Rails application.
# This script must be run in the base directory of the application. (the one that contains app/, db/, Gemfile, and other such files)
#
# Checks that the Ruby gem bundle is up to date.
# Checks that documentation is properly linked and updated.
# Checks that database files are present and updated.
# If nothing goes wrong, then it will start the Rails application.

DASHBOARD_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Gem Check
# ---------
# check that the gems in Gemfile are up to date and update if needed
bundle check
if [ $? -ne 0 ]
then
  bundle update
fi


# Documentation Check 
# -------------------
if [ -e "$DASHBOARD_DIR/doc" ]
then
  if [ -L "$DASHBOARD_DIR/doc" ]
  then
    if [ `readlink -f "$DASHBOARD_DIR/doc"` = "$DASHBOARD_DIR/public/doc" ]
    then
      echo "doc/ -> public/doc/ symlink already set up properly, moving on..."
    else
      echo "doc/ symlink does not point to public/doc, fixing and moving on..."
      rm "$DASHBOARD_DIR/doc"
      ln -s public/doc doc
    fi
  else
    echo "$DASHBOARD_DIR/doc is not a symbolic link. Moving current doc to doc-old..."
    mv "$DASHBOARD_DIR/doc" "$DASHBOARD_DIR/doc-old"
    
    echo "Creating symbolic link doc/ -> public/doc/..."
    ln -s public/doc doc
  fi
else
  echo "$DASHBOARD_DIR/doc does not exist."
  echo "Creating symbolic link doc -> public/doc..."
  ln -s public/doc doc
fi

# update documentation
rake doc:app


# Database Check
# --------------
SQLITE_FILECOUNT=$(ls $DASHBOARD_DIR/db/*.sqlite3 2> /dev/null | wc -l)
# initialize database files if no database files exist
if [ "$SQLITE_FILECOUNT" = "0" ]
then
  echo "No .sqlite3 files in db/, initalizing database files with rake db:automigrate..."
  rake db:automigrate
# upgrade database files if already there
else
  echo "Running rake db:autupgrade on already existing .sqlite3 files..."
  rake db:autoupgrade
fi 


# Start Rails
# -----------
rails server -d