# Model for Sonar source code reports.
#
# Based on Extensions::WidgetBase, which gives it a +name+ property, as well as the +html_id+ and +html_class+ virtual properties. This is a kind of Widget.
#
# == Unique Properties
# - +package_name+ (String): Package name as tracked by Sonar. Required property.
# - +metrics_to_track+ (Text): A comma-separated list of metrics to track. A list of available metrics can be found here[http://docs.codehaus.org/display/SONAR/Metric+definitions]. Default is "<code>ncloc,coverage</code>". Required property.
# - +sonar_server+ (Text): Address of the Sonar server to retrieve information from. An example of such of an address is "<code>http://sonar-server:9000/</code>". Required property.
class SonarReport
  include Extensions::WidgetBase
  
  property :package_name,       DataMapper::Property::String,   :required => true
  property :metrics_to_track,   DataMapper::Property::Text,     :required => true,  :default => "ncloc,coverage"
  property :sonar_server,       DataMapper::Property::Text,     :required => true
end
