module Extensions #:nodoc:
  # Module to be included by every model that will interact with JIRA.
  # 
  # == Properties
  # - +jira_server+ (Text): Address of a server running JIRA. Required property.
  # - +project+ (String): Short name of a project in JIRA. Required property.
  # - +version+ (String): Version of JIRA project to check against. A specific version can be supplied, but if this property is set to "<code>current</code>", it will check against the next version to be released. Default is "<code>current</code>". Required property.
  # - +username+ (String): Username to log in to JIRA with. Required property.
  # - +password+ (String): Password to log in to JIRA with. Unfortunately stored in plain text due to limitations with the JIRA SOAP API. Required property.
  #
  # == Virtual Properties
  # - +full_project_name+ (String): The full name of a project specified by its abbreviated name. Connects to JIRA.
  # - +next_release+ (Hash): A hash describing the next version of a JIRA project. Contains keys for +name+ (String) and +release_date+ (DateTime). Connects to JIRA.
  # - +true_version+ (String): The name of the next to-be-released version of a JIRA project. Connects to JIRA if necessary.
  module JiraBase
    extend ActiveSupport::Concern
    
    included do
      property :jira_server,            DataMapper::Property::Text,     :required => true
      property :project,                DataMapper::Property::String,   :required => true
      property :version,                DataMapper::Property::String,   :required => true,    :default => "current"
      property :username,               DataMapper::Property::String,   :required => true
      property :password,               DataMapper::Property::String,   :required => true
    end
    
    # Methods used to pull additional data from JIRA.
    module InstanceMethods
      # Log into JIRA if necessary.
      def login
        if(!defined? @jira)
          @jira = Jira4R::JiraTool.new(2, self.jira_server)
          @jira.login(self.username, self.password)
        end
      end
      
      # The full name of a project specified by its abbreviated name. Connects to JIRA. 
      def full_project_name
        self.login
        
        @jira.getProject(self.project).name    
      end
      
      # The name of the next version of a JIRA project. If +version+ is not "<code>current</code>", this will just return the value of +version+ as-is. Connects to JIRA if +version+ is "<code>current</code>".
      def true_version
        # supplied version is "current"
        if self.version.casecmp("current") == 0
          self.next_release["name"]
        # supplied version is not "current", just return supplied version
        else 
          self.version
        end
      end
      
      # Determines the next upcoming version associated with a JIRA project. Returns a Hash containing +name+ and +release_date+ keys. Connects to JIRA.
      def next_release
        self.login
        
        versions = @jira.getVersions(self.project)
        
        # create an array of versions with release dates in the future and sort it
        release_dates = Array.new;
        
        # populate release date array with hashes
        versions.each do |version|
          if(version.releaseDate != nil && version.releaseDate.future?)
            release_dates.push({'name' => version.name, 'release_date' => version.releaseDate})
          end
        end
        
        # sort array by release_date key in hash
        release_dates = release_dates.sort_by do | version |
          version["release_date"]
        end
        
        # return name of the first version in the array
        release_dates[0]
      end
    end
  end
end