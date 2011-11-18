# Model that represents a Dashboard that the user can view. A Dashboard can have many Widgets on it. The Widgets that belong to a Dashboard are defined by DashboardWidget. See the documentation for DashboardWidget for more details.
#
# == Properties
# - +name+ (String): Displayed name of this Dashboard
#
# == Virtual Properties
# - +columns+ (Integer): Number of columns this dashboard has
class Dashboard
  include DataMapper::Resource
  include Extensions::PrettyParam
  
  property :id,         DataMapper::Property::Serial
  property :name,       DataMapper::Property::String,   :required => true
  
  has n, :dashboard_widgets
  has n, :widgets, :through => :dashboard_widgets
  
  # Return a collection of Dashboards, useful for generating a navbar.
  # 
  # Currently just returns all Dashboards.
  def self.displayable_dashboards
    all
  end
  
  # Return the number of columns this dashboard should have based on the maximum values of +column_id+ for all DashboardWidgets belonging to this Dashboard.
  def columns
    DashboardWidget.max(:column_id, :dashboard_id => self.id);
  end
end
