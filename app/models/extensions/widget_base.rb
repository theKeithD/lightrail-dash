module Extensions #:nodoc:
  # Module to be included by every model that will be used as a Widget.
  # 
  # Includes DataMapper::Resource and Extensions::PrettyParam automatically.
  # Defines callback methods to hook into DataMapper.
  # 
  # == Properties
  # - +name+ (String): The displayed name of this item. Required property.
  #
  # == Virtual Properties
  # - +html_id+ (String): A parameterized version of +name+, combined with the Widget's class name.
  # - +html_class+ (String): A parameterized version of the Widget's class name.
  module WidgetBase
    extend ActiveSupport::Concern
    
    included do
      include DataMapper::Resource
      include Extensions::PrettyParam
      
      property :id,     DataMapper::Property::Serial
      property :name,   DataMapper::Property::String, :required => true
      
      after :save, :update_widget
      before :destroy, :remove_widget
    end
    
    # Methods called by DataMapper's lifecycle hooks.
    module InstanceMethods
      # Updates the Widget listing with an entry for this item.
      # 
      # Called after saving the object.
      def update_widget
        widget = Widget.first_or_create({:widgetable_id => self.id, :widgetable_type => ActiveSupport::Inflector.tableize(self.class.name.split('::').last).singularize})
      end
      
      # Removes the appropriate entry for this item from the Widget listing, and any references to it in DashboardWidget.
      # 
      # Called before destroying the object.
      def remove_widget
        Widget.first({:widgetable_id => self.id, :widgetable_type => ActiveSupport::Inflector.tableize(self.class.name.split('::').last).singularize}).destroy
        
        DashboardWidget.all(:widget_id => self.id).destroy
      end
      
      # A parameterized version of +name+, combined with the Widget's class name.
      def html_id
        "#{self.class.name.underscore.humanize}-#{self.name}".parameterize
      end
      
      # A parameterized version of the Widget's class name.
      def html_class
        self.class.name.underscore.humanize.parameterize
      end
    end
  end
end
