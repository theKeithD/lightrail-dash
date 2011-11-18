# Monitoring Dashboard
A Rails application designed to pull data from various reporting sources and display it in configurable dashboards.

## Installation
1. Download the contents of this repository.
2. Run `./setup_dashboard.sh`. This will ensure that the proper gems are installed and up to date, the documentation is in place and updated, and that the databases are set up properly. After all that, it will start the Rails application.
  - To start the application on your own, just run `rails server -d`.
3. Enjoy!

## Before committing
Please remember to update the documentation if you have modified anything in *app/*. To update documentation, run `rake doc:app`.
If the database structure has been modified, run `rake db:autoupgrade`.

## Places to Know
- `/doc` - Documentation!
- `/doc/app/Widget.html` - Widget documentation page, contains a good amount of info to get started on
- `/dashboards/` - A listing of all Dashboards
- `/dashboards/1` - Display a specific Dashboard
- `/dashboards/1/widgets` - Display the Widgets belonging to a specific Dashboard
- `/widgets/` - A listing of all Widgets available for use
- `/widgets/1` - Display a specific Widget. Redirects to the appropriate Widget type.
- `/widgets/1/embed` - HTML to include the given Widget on another page
- `/ganglia_graphs/1/data.json` - JSON data for a Ganglia graph

