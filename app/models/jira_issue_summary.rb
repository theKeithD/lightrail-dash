# Model for tracking the number of issues in a JIRA instance. Retrieves information both about the status of issues for a particular version, but also the type of each issue.
#
# Based on Extensions::WidgetBase, which gives it a +name+ property, as well as the +html_id+ and +html_class+ virtual properties. This is a kind of Widget.
# Based on Extensions::JiraBase, which gives it the +jira_server+, +project+, +version+, +username+, and +password+ properties, as well as the +full_project_name+ and +current_version+ virtual properties.
#
# == Unique Properties
# - +statuses_open+ (Text): A comma-separated list of issue statuses to count as "Open". Default is "<code>Open, Reopened</code>". Required property.
# - +statuses_in_progress+ (Text): A comma-separated list of issue statuses to count as "In Progress". Default is "<code>In Progress, Ready for QA, Verified</code>". Required property.
# - +statuses_closed+ (Text): A comma-separated list of issue statuses to count as "Closed". Default is "<code>Closed, PO Approved</code>". Required property.
#
# == Virtual Properties
# - +issue_counts+ (Hash): Runs JQL queries against a JIRA instance to retrieve the number of closed, in progress, and open issues for a given project. Hash keys are +open+, +in_progress+, and +closed+. Connects to JIRA.
# - +issue_types+ (Hash): Runs JQL queries against a JIRA instance to retrieve the number of bugs, stories, and tasks for a given project. Hash keys are +bug+, +story+, and +task+. Connects to JIRA.
#
class JiraIssueSummary
  include Extensions::WidgetBase
  include Extensions::JiraBase
  
  property :statuses_open,          DataMapper::Property::Text,     :required => true,  :default => "Open, Reopened"
  property :statuses_in_progress,   DataMapper::Property::Text,     :required => true,  :default => "In Progress, Ready for QA, Verified"
  property :statuses_closed,        DataMapper::Property::Text,     :required => true,  :default => "Closed, PO Approved"
  
  # Normalizes a comma-separated list so that each item in the list is wrapped in quotation marks.
  def self.parse_statuses(status_list)
    status_array = status_list.split(",")
    status_array.map! do |status|
      '"' + status.strip.sub(/^"/, "").sub(/"$/, "") + '"'
    end
    
    status_array.join(", ")
  end

  # Runs JQL queries against a JIRA instance to retrieve the number of closed, in progress, and open issues for a given project. Returns a hash with the keys +open+, +in_progress+, and +closed+. Connects to JIRA.
  def issue_counts
    self.login
    
    issue_counts = Hash.new
    version = self.true_version
    full_name = self.full_project_name
    
    # Hooray, magic numbers. Why couldn't you make them optional, API? Let's hope that nobody has more than 9999 issues in any one state at once.
    # If there are anywhere close to 9999 issues, then we could be here all day, anyways.
    issue_counts['open'] = @jira.getIssuesFromJqlSearch('project = "' + full_name + '" AND (fixVersion = "' + version + '" OR "Release Version History" = "' + version + '") AND status in (' + JiraIssueSummary.parse_statuses(self.statuses_open) + ')', 9999).length
    issue_counts['in_progress'] = @jira.getIssuesFromJqlSearch('project = "' + full_name + '" AND (fixVersion = "' + version + '" OR "Release Version History" = "' + version + '") AND status in (' + JiraIssueSummary.parse_statuses(self.statuses_in_progress) + ')', 9999).length
    issue_counts['closed'] = @jira.getIssuesFromJqlSearch('project = "' + full_name + '" AND (fixVersion = "' + version + '" OR "Release Version History" = "' + version + '") AND status in (' + JiraIssueSummary.parse_statuses(self.statuses_closed) + ')', 9999).length
    
    issue_counts
  end
  
  # Runs JQL queries against a JIRA instance to retrieve the number of bugs, features, and tasks for a given project. Returns a hash with the keys +bug+, +feature+, and +task+. Connects to JIRA.
  def issue_types
    self.login
    
    issue_types = Hash.new
    version = self.true_version
    full_name = self.full_project_name
    
    issue_types['bug'] = @jira.getIssuesFromJqlSearch('project = "' + full_name + '" AND (fixVersion = "' + version + '" OR "Release Version History" = "' + version + '") AND type = "Bug"', 9999).length
    issue_types['story'] = @jira.getIssuesFromJqlSearch('project = "' + full_name + '" AND (fixVersion = "' + version + '" OR "Release Version History" = "' + version + '") AND type = "Story"', 9999).length
    issue_types['task'] = @jira.getIssuesFromJqlSearch('project = "' + full_name + '" AND (fixVersion = "' + version + '" OR "Release Version History" = "' + version + '") AND type = "Task"', 9999).length
    
    issue_types
  end
end
