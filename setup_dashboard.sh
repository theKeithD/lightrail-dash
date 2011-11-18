#/bin/bash
# Script to assist with first-time setup of the Dashboard Rails application.
# This script must be run in the base directory of the application. (the one that contains app/, db/, Gemfile, and other such files)
#
# Checks that the Ruby gem bundle is up to date.
# Checks that documentation is properly linked and updated.
# Checks that database files are present and updated.
# If nothing goes wrong, then it will start the Rails application.

DASHBOARD_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Color Setup
# -----------
bold=$(tput bold)                 # bold
boldred=${bold}$(tput setaf 1)    # red
boldyellow=${bold}$(tput setaf 3) # yellow
boldgreen=${bold}$(tput setaf 2)  # green
boldwhite=${bold}$(tput setaf 7)  # white
reset=$(tput sgr0)                # reset
info="${boldwhite}* "
pass="${boldgreen}* "
warn="${boldyellow}! "
fail="${boldred}! "

# Gem Check
# ---------
# check that the gems in Gemfile are up to date and update if needed
echo -e "${info}Checking bundle...${reset}"
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
      echo "${pass}doc/ -> public/doc/ symlink already set up properly, moving on...${reset}"
    else
      echo "${warn}doc/ symlink does not point to public/doc, fixing and moving on...${reset}"
      rm "$DASHBOARD_DIR/doc"
      ln -s public/doc doc
    fi
  else
    echo "${fail}$DASHBOARD_DIR/doc is not a symbolic link.${reset} ${warn}Moving current doc to doc-old...${reset}"
    mv "$DASHBOARD_DIR/doc" "$DASHBOARD_DIR/doc-old"
    
    echo "${info}Creating symbolic link doc/ -> public/doc/...${reset}"
    ln -s public/doc doc
  fi
else
  echo "${fail}$DASHBOARD_DIR/doc does not exist.${reset}"
  echo "${info}Creating symbolic link doc -> public/doc...${reset}"
  ln -s public/doc doc
fi

# update documentation
echo "${info}Updating documentation...${reset}"
rake doc:app


# Database Check
# --------------
SQLITE_FILECOUNT=$(ls $DASHBOARD_DIR/db/*.sqlite3 2> /dev/null | wc -l)
# initialize database file if no database file exist
if [ "$SQLITE_FILECOUNT" = "0" ]
then
  echo "${warn}No .sqlite3 files in db/, initalizing database file with rake db:automigrate...${reset}"
  rake db:automigrate
# upgrade database file if already there
else
  echo "${info}Running rake db:autupgrade on already existing .sqlite3 file...${reset}"
  rake db:autoupgrade
fi 


# Start Rails
# -----------
echo "${info}Starting Rails...${reset}"
rails server -d
