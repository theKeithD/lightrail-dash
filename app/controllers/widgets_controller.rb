class WidgetsController < ApplicationController
  caches_page :index, :show, :embed
  
  # GET /widgets
  # GET /widgets.xml
  def index
    # narrow down to a single Dashboard's widgets if dashboard_id is given
    if params[:dashboard_id]
      @widgets = Array[];
      @dashboard_widgets = Array(DashboardWidget.all(:dashboard_id => params[:dashboard_id]))
      @dashboard_widgets.each do |dashboard_widget|
        @widgets.push(Widget.get(dashboard_widget.widget_id))
      end
    else
      @widgets = Widget.all
    end
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @widgets }
    end
  end

  # GET /widgets/1
  # GET /widgets/1.xml
  def show
    @widget = Widget.get(params[:id])
    
    respond_to do |format|
      format.html { redirect_to polymorphic_path(@widget.widgetable_type.classify.constantize.get(@widget.widgetable_id)) }
      format.xml  { render :xml => @widget }
    end
  end

  # GET /widgets/new
  # GET /widgets/new.xml
  def new
    expire_page :action => :index
    expire_page :action => :show
    expire_page :action => :embed
    
    @widget = Widget.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @widget }
    end
  end

  # GET /widgets/1/edit
  def edit
    expire_page :action => :index
    expire_page :action => :show
    expire_page :action => :embed
    
    @widget = Widget.get(params[:id])
  end

  # POST /widgets
  # POST /widgets.xml
  def create
    expire_page :action => :index
    expire_page :action => :show
    expire_page :action => :embed
    
    @widget = Widget.new(params[:widget])

    respond_to do |format|
      if @widget.save
        format.html { redirect_to(@widget, :notice => 'Widget was successfully created.') }
        format.xml  { render :xml => @widget, :status => :created, :location => @widget }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @widget.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /widgets/1
  # PUT /widgets/1.xml
  def update
    expire_page :action => :index
    expire_page :action => :show
    expire_page :action => :embed
    
    @widget = Widget.get(params[:id])

    respond_to do |format|
      if @widget.update(params[:widget])
        format.html { redirect_to(@widget, :notice => 'Widget was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @widget.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /widgets/1
  # DELETE /widgets/1.xml
  def destroy
    expire_page :action => :index
    expire_page :action => :show
    expire_page :action => :embed
    
    @widget = Widget.get(params[:id])
    @widget.destroy

    respond_to do |format|
      format.html { redirect_to(widgets_url) }
      format.xml  { head :ok }
    end
  end
  
  # GET /widgets/1/embed
  def embed
    @widget = Widget.get(params[:id])
    
    respond_to do |format|
      format.html { render :layout => false, :content_type => "text/javascript" } # embed.html.erb
    end
  end
end
