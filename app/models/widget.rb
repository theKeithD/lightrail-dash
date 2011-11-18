# Model for objects that can be displayed as Widgets on a Dashboard.
# There are many kinds of widgets, each with their own associated model.
# All flavors of Widgets are accessible from Widget using methods from WidgetsHelper.
# 
# A Widget object merely stores the widget's type and the ID by which it can be found.
# 
# == Making More Widget Types
# Start off with running this command to generate a basic structure for this new widget type.
#   $ rails generate scaffold LaserBeams color:string number_of_beams:string
# Or copy files from an already existing widget type such as SonarReport.
# Replace the `include` statement at the top of the model definition with the following line:
#   include Extensions::WidgetBase
# This will include DataMapper::Resource automatically, so there is no need for <code>include DataMapper::Resource</code> in the widget model. Additionally, it will also include the common properties and methods shared by all Widget subtypes.
# Then add a line like the following to the end of this class (+widget.rb+):
#   has n, :laser_beams
# After that, start modifying the views, making sure to create a partial named after the object, such as `_laser_beam.html.erb`. This is what will be used to render the object onto a Dashboard.
#
# == Properties
# - +widgetable_id+ (Integer): The ID of the widget in its corresponding table.
# - +widgetable_type+ (String): The type of widget this item is. Stored as a singularized version of its corresponding database table name. For example, GangliaGraph would be +ganglia_graph+.
#
# == Children
# - GangliaGraph - Ganglia system monitor graphs.
# - GithubCommit - Recent items from GitHub commit feeds.
# - HudsonBuildStatus - Statuses of various Hudson build jobs.
# - JiraCountdown - Days remaining until the next release of a JIRA project.
# - JiraIssueSummary - Issue counts for JIRA projects.
# - SonarReport - Sonar source code reports.
# - VerticalSpacer - Purely cosmetic widget for vertical spacing.
class Widget
  include DataMapper::Resource
  include Extensions::PrettyParam
  
  property :id,                 DataMapper::Property::Serial
  property :widgetable_id,      DataMapper::Property::Integer
  property :widgetable_type,    DataMapper::Property::String
  
  has n, :dashboard_widgets
  has n, :dashboards, :through => :dashboard_widgets
  
  has n, :ganglia_graphs
  has n, :sonar_reports
  has n, :jira_countdowns
  has n, :jira_issue_summaries
  has n, :hudson_build_statuses
  has n, :github_commits
  has n, :vertical_spacers
end
