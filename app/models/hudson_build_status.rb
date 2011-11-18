# Model for tracking the statuses of Hudson build jobs.
#
# Based on Extensions::WidgetBase, which gives it a +name+ property, as well as the +html_id+ and +html_class+ virtual properties. This is a kind of Widget.
#
# == Unique Properties
# - +hudson_server+ (Text) - Address of a Hudson build server. An example of such an address is "<code>http://hudson-server/hudson/</code>". Required property.
# - +build+ (Text) - Regular expression to filter desired jobs by name. Values can be as simple as "<code>deploy</code>", which will show only jobs that have "<code>deploy</code>" in their name. Required property.
#
# == Virtual Properties
# - +api_uri+ (String) - URI of the remote API call used by HudsonBuildStatus. Takes the value of +hudson_server+ and appends "<code>api/json?tree=jobs[name,color,url]</code>" to it.
class HudsonBuildStatus
  include Extensions::WidgetBase
  
  property :hudson_server,          Text,     :required => true
  property :build,                  Text,     :required => true
  property :show_overall_status,    Boolean,  :required => true,  :default => 1
  
  # URI of the remote API call used by HudsonBuildStatus. Takes the value of +hudson_server+ and appends "<code>api/json?tree=jobs[name,color,url]</code>" to it.
  def api_uri
    self.hudson_server + "api/json?tree=jobs[name,color,url]"
  end
end
