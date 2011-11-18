class DashboardWidgetsController < ApplicationController
  caches_page :index, :show

  # GET /dashboard_widgets
  # GET /dashboard_widgets.xml
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

  # GET /dashboard_widgets/1
  # GET /dashboard_widgets/1.xml
  def show
    @widget = Widget.get(params[:id])
    
    respond_to do |format|
      format.html { redirect_to polymorphic_path(@widget.widgetable_type.classify.constantize.get(@widget.widgetable_id)) }
      format.xml  { render :xml => @widget }
    end
  end

  # GET /dashboard_widgets/new
  # GET /dashboard_widgets/new.xml
  def new
    expire_page :action => :index
    expire_page :action => :show

    @widget = Widget.new
    
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @widget }
    end
  end

  # GET /dashboard_widgets/1/edit
  def edit
    expire_page :action => :index
    expire_page :action => :show

    @widget = Widget.get(params[:id])
  end

  # POST /dashboard_widgets
  # POST /dashboard_widgets.xml
  def create
    @widget = Widget.new(params[:widget])

    respond_to do |format|
      if @widget.save
        expire_page :action => :index
        expire_page :action => :show

        format.html { redirect_to(@widget, :notice => 'Widget was successfully created.') }
        format.xml  { render :xml => @widget, :status => :created, :location => @widget }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @widget.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /dashboard_widgets/1
  # PUT /dashboard_widgets/1.xml
  def update
    expire_page :action => :index
    expire_page :action => :show

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

  # DELETE /dashboard_widgets/1
  # DELETE /dashboard_widgets/1.xml
  def destroy
    expire_page :action => :index
    expire_page :action => :show


    @widget = Widget.get(params[:id])
    @widget.destroy

    respond_to do |format|
      format.html { redirect_to(widgets_url) }
      format.xml  { head :ok }
    end
  end
end
