# Model for retrieving the latest commits from GitHub, either from a user's watchlist or from a specific repository branch.
#
# Based on Extensions::WidgetBase, which gives it a +name+ property, as well as the +html_id+ and +html_class+ virtual properties. This is a kind of Widget.
#
# == Unique Properties
# - +github_username+ (String) - Name of a user or organization on GitHub that owns the desired repository. Required property.
# - +track_user_watchlist+ (Boolean) - Whether or not to retrieve data from a GitHub user's personal feed. If this is enabled, only +github_username+ and potentially +auth_token+ are required. Default is <code>false</code>. Required property.
# - +github_repository+ (String) - Name of the repository to track. Required property if :track_user_watchlist is +false+.
# - +branch+ (String) - Name of the branch to track. Default is "<code>master</code>". Required property if :track_user_watchlist is +false+.
# - +commits_to_show+ (Integer) - Number of recent commits to show. Default is <code>5</code>. Required property.
# - +private_feed+ (Boolean) - Whether or not +github_repository+ is private or not. If it is, +auth_login+ and +auth_token+ must also be provided. Default is <code>true</code>. Required property.
# - +auth_login+ (String) - The username of a GitHub user authorized to view this repository. Required property if +private_feed+ is +true+.
# - +auth_token+ (Text) - An authorization token for a GitHub user authorized to view this repository. Your token can be found at https://github.com/account/admin under the <b>API Token</b> section. Required property if +private_feed+ is +true+.
#
# == Virtual Properties
# - +feed_uri+ (String) - URI of the Atom feed used by GithubCommit. Combines the values of all of other properties appropriately.
# - +codebase_uri+ (String) - URI of the GitHub page that holds this branch's code, or if +track_user_watchlist+ is +true+, the user's profile.
# - +recent_commits+ (Array) - Hashes of recent commits, limited by +commits_to_show+.
class GithubCommit
  include Extensions::WidgetBase
  include RemoteDataHelper
  
  property :github_username,        String,     :required => true
  property :track_user_watchlist,   Boolean,    :required => true,  :default => 0
  property :github_repository,      String
  property :branch,                 String,     :default => "master"
  property :commits_to_show,        Integer,    :required => true,  :default => 5
  property :private_feed,           Boolean,    :required => true,  :default => 1
  property :auth_login,             String
  property :auth_token,             Text
  
  validates_presence_of :auth_login, :if => lambda { |g| g.private_feed? && !g.track_user_watchlist? == true } # auth_login only required for a private repository feed
  validates_presence_of :auth_token, :if => :private_feed?
  
  validates_absence_of :auth_login, :if => lambda { |g| !g.private_feed? || g.track_user_watchlist? == true } # auth_login should be empty for a public feed or a user feed
  validates_absence_of :auth_token, :unless => :private_feed?
  
  validates_presence_of :github_repository, :unless => :track_user_watchlist?
  validates_presence_of :branch, :unless => :track_user_watchlist?

  validates_absence_of :github_repository, :if => :track_user_watchlist?
  validates_absence_of :branch, :if => :track_user_watchlist?
  
  
  # URI of the Atom feed used by GithubCommit. Combines the values of all of other properties appropriately.
  def feed_uri
    extra_parameters = ""
    
    if(self.private_feed?)
      extra_parameters = "?"
      if(!self.track_user_watchlist?)
        extra_parameters << "login=#{self.auth_login}&"
      end
      extra_parameters << "token=#{self.auth_token}"
    end
    
    if(self.track_user_watchlist?)
      "https://www.github.com/#{self.github_username}.#{self.private_feed ? 'private.' : '' }atom" + extra_parameters
    else
      "https://www.github.com/#{self.github_username}/#{self.github_repository}/commits/#{self.branch}.atom" + extra_parameters
    end
  end
  
  # URI of the GitHub page that holds this branch's code, or if +track_user_watchlist+ is +true+, the user's profile.
  def codebase_uri
      if(self.track_user_watchlist?)
        "http://github.com/#{self.github_username}"
      else
        "https://www.github.com/#{self.github_username}/#{self.github_repository}/tree/#{self.branch}"
      end
  end
  
  # An array of recent commits, limited by +commits_to_show+. Each commit is stored as a hash with +id+, +description+, +uri+, +date+, and +author+ as keys.
  def recent_commits
    require 'nokogiri'
    
    feed = Nokogiri::XML(remote_xml(self.feed_uri))

    namespaces = {"atom" => "http://www.w3.org/2005/Atom"}
    xpath_query = "//atom:entry[position()<#{self.commits_to_show + 1}]"
    
    commits = feed.xpath(xpath_query, namespaces).map do |entry|
      {'id' => entry.xpath('atom:link', namespaces).first['href'].split('/').last,
       'description' => entry.xpath('atom:title', namespaces).inner_text, 
       'uri' => entry.xpath('atom:link', namespaces).first['href'],
       'date' => entry.xpath('atom:updated', namespaces).inner_text, 
       'author' => entry.xpath('atom:author/atom:name', namespaces).inner_text}
    end
  end
end
