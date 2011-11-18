# Model for a purely cosmetic vertical spacer to use on a Dashboard.
#
# Based on Extensions::WidgetBase, which gives it a +name+ property, as well as the +html_id+ and +html_class+ virtual properties. This is a kind of Widget.
#
# == Unique Properties
# - +height+ (String): Height of spacer, as it would be entered in a stylesheet. Recommended units are +px+ and +em+. Default is "<code>10em</code>". Required property.
class VerticalSpacer
  include Extensions::WidgetBase
  
  property :height,     DataMapper::Property::String,   :required => true,  :default => "10em"
end