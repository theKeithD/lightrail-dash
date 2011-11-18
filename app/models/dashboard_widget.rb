# Model to join Dashboards and Widgets with one another. Each DashboardWidget object contains the ID of both a Dashboard and a Widget. This is where a Dashboard's content is essentially defined.
#
# At the moment, adding Widgets to a Dashboard requires database access. Connect to the application's database with the following command:
#     $ sqlite3 db/production.sqlite3
# Once inside, run a query against the database similar to the following:
#     sqlite> insert into dashboard_widgets (dashboard_id, widget_id, column_id) values(X, Y, Z);
# Where X is the ID of the Dashboard to add a Widget to, Y is the ID of the Widget to add, and Z is the column to place the Widget in. The Widget ID is found in the widgets table, or by looking at +/widgets+ in the app.
#
# == Properties
# - +dashboard_id+ (Integer): The ID of the desired Dashboard.
# - +widget_id+ (Integer): The ID of the desired Widget.
# - +column_id+ (Integer): Column to place the desired Widget in. The Dashboard that includes this DashboardWidget will use this for determining the layout of the Dashboard.
class DashboardWidget
  include DataMapper::Resource
  
  property :id,         Serial
  property :column_id,  Integer,    :required => true,  :default => 1
  
  belongs_to :dashboard, :key => true
  belongs_to :widget, :key => true
end
