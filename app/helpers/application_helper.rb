# Helper methods associated with no specific module.
module ApplicationHelper
  include RemoteDataHelper
  
  # Generate a context-appropriate title for a page.
  #
  # Default title is "Nifty Monitoring Dashboard".
  # Title will change when viewing a Dashboard or Widgets belonging to a Dashboard.
  def page_title
    if controller.controller_name == "dashboards" && params.key?("id")
      "Nifty #{Dashboard.get(params[:id]).name}"
    elsif controller.controller_name == "widgets" && params.key?("dashboard_id")
      "Nifty #{Dashboard.get(params[:dashboard_id]).name} Widgets"
    else
      "Nifty Monitoring Dashboard"
    end
  end  
end
