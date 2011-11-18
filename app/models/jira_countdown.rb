# Model for tracking the number of days left until the release of the next JIRA project version.
#
# Based on Extensions::WidgetBase, which gives it a +name+ property, as well as the +html_id+ and +html_class+ virtual properties. This is a kind of Widget.
# Based on Extensions::JiraBase, which gives it the +jira_server+, +project+, +version+, +username+, and +password+ properties, as well as the +full_project_name+ and +current_version+ virtual properties.
#
# == Virtual Properties
# +days_remaining+ (Integer) - Calculates the number of days between the next release date and the current date.
class JiraCountdown
  include Extensions::WidgetBase
  include Extensions::JiraBase
  
  # Calculates the number of days between the next release date and the current date.
  def days_remaining
    target_time = self.next_release["release_date"].to_time
    current_time = Time.now
    
    difference_seconds = target_time - current_time
    difference_seconds.div(86400) # seconds in a day
  end
end
