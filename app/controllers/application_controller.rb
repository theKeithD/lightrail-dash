class ApplicationController < ActionController::Base
  protect_from_forgery
  caches_page :index
  
  # GET /
  def index
    respond_to do |format|
      format.html { # index.html.erb
        @dashboards = Dashboard.all
      }
    end
  end
end
