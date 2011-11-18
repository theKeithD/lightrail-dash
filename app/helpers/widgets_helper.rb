module WidgetsHelper
  # Returns a path to the given widget.
  #
  # Additional arguments will be passed to the +polymorphic_path+ helper
  def true_widget_path(widget, args=nil)
    if args
      polymorphic_path(true_widget(widget), args)
    else
      polymorphic_path(true_widget(widget))
    end
  end
  
  # Return a path to a listing of the given widget's type.
  def true_widget_listing_path(widget)
    polymorphic_path(widget_type(widget))
  end
  
  # Get the actual widget from its appropriate model.
  def true_widget(widget)
    widget_type(widget).get(widget.widgetable_id)
  end
  
  # Determine what type of widget the given Widget is.
  # 
  # Returned value is a constant, so the following is possible:
  # <code>widget_type(widget).get(35)</code>
  def widget_type(widget)
    widget.widgetable_type.pluralize.classify.constantize
  end
  
  # Gather an array of Widgets that belong to a given Dashboard. Each item in the array is a hash containing values for +widget+ and +column+.
  def widgets_for_dashboard(dashboard)
    widgets = Array[];
    dashboard_widgets = Array(DashboardWidget.all(:dashboard_id => dashboard.id))
    dashboard_widgets.each do |dashboard_widget|
      widgets.push({"widget" => Widget.get(dashboard_widget.widget_id), "column" => dashboard_widget.column_id})
    end
    
    widgets
  end
end
