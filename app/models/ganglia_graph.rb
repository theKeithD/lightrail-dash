# Model for Ganglia system monitor graphs.
#
# Based on Extensions::WidgetBase, which gives it a +name+ property, as well as the +html_id+ and +html_class+ virtual properties. This is a kind of Widget.
#
# == Unique Properties
# - +uri+ (Text): URI for JSON data from Ganglia. An example of a usable URI can be found here[http://ganglia-server/gweb2/graph.php?r=4hr&hreg[]=DESIRED_HOSTS&mreg[]=load_five&gtype=line&vl=&title=&aggregate=1&json=1]. Required property.
# - +kind+ (String): The type of graph this data represents. In 99% of cases, the default value is fine. Default is "+time+". If the graph's legend shows several "<code>__SummaryInfo__</code>" series, use "+report+" instead. Permitted values are "+time+" and "+report+".
# - +description+ (String): Optional short description that provides additional info about this data. Default is "<code>past 4 hours</code>".
class GangliaGraph
  include Extensions::WidgetBase
  
  property :uri,            DataMapper::Property::Text,     :required => true
  property :kind,           DataMapper::Property::String,   :default => "time"
  property :description,    DataMapper::Property::String,   :default => "past 4 hours"
  
  validates_within :kind, :set => ['time', 'report']
end
