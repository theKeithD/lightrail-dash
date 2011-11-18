module Extensions #:nodoc:
  # Module to add a slug to a model in order to produce friendlier URIs. Requires a +name+ property in the model that includes this module.
  # TODO: Make this play nice with DataMapper
  module PrettyParam
    extend ActiveSupport::Concern
    
    included do
    #  property :slug,       DataMapper::Property::Slug      
    #  require "friendly_id"
    #  require "friendly_id/datamapper"
      
    #  has_friendly_id :name, :use_slug => true
      
    #  is :sluggable
    #  property :slug,   DataMapper::Property::String
    #  
    #  before :create do
    #    pretty_name = self.id
    #    if defined? self.name
    #      pretty_name += "-#{self.name.parameterize}"
    #    end
    #    
    #    set_slug(pretty_name.to_slug)
    #  end
    end
    
    module InstanceMethods
      # Override +to_param+ to also include an object's name in the URL.
      # 
      # Currently disabled (and broken!) due to DataMapper switch.
      #def to_param
      #  if defined? self.namee # <-- drop the 'e' to enable
      #    "#{id}-" + ActiveSupport::Inflector.parameterize(self.name)
      #  else
      #    "#{id}"
      #  end
      #end
      def prepare_slug
        if defined? self.name
          self.name.downcase.gsub(/\W/,'-').squeeze('-').chomp('-')
        else
          "#{id}"
        end
      end
    end
  end
end
