class HudsonBuildStatusesController < ApplicationController
  caches_page :index, :show

  # GET /hudson_build_statuses
  # GET /hudson_build_statuses.xml
  def index
    @hudson_build_statuses = HudsonBuildStatus.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @hudson_build_statuses }
    end
  end

  # GET /hudson_build_statuses/1
  # GET /hudson_build_statuses/1.xml
  def show
    @hudson_build_status = HudsonBuildStatus.get(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @hudson_build_status }
    end
  end

  # GET /hudson_build_statuses/new
  # GET /hudson_build_statuses/new.xml
  def new
    expire_page :action => :index
    expire_page :action => :show
    
    @hudson_build_status = HudsonBuildStatus.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @hudson_build_status }
    end
  end

  # GET /hudson_build_statuses/1/edit
  def edit
    expire_page :action => :index
    expire_page :action => :show
    
    @hudson_build_status = HudsonBuildStatus.get(params[:id])
  end

  # POST /hudson_build_statuses
  # POST /hudson_build_statuses.xml
  def create
    expire_page :action => :index
    expire_page :action => :show
    
    @hudson_build_status = HudsonBuildStatus.new(params[:hudson_build_status])

    respond_to do |format|
      if @hudson_build_status.save
        format.html { redirect_to(@hudson_build_status, :notice => 'Hudson build status was successfully created.') }
        format.xml  { render :xml => @hudson_build_status, :status => :created, :location => @hudson_build_status }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @hudson_build_status.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /hudson_build_statuses/1
  # PUT /hudson_build_statuses/1.xml
  def update
    expire_page :action => :index
    expire_page :action => :show
    
    @hudson_build_status = HudsonBuildStatus.get(params[:id])

    respond_to do |format|
      if @hudson_build_status.update(params[:hudson_build_status])
        format.html { redirect_to(@hudson_build_status, :notice => 'Hudson build status was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @hudson_build_status.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /hudson_build_statuses/1
  # DELETE /hudson_build_statuses/1.xml
  def destroy
    expire_page :action => :index
    expire_page :action => :show
    
    @hudson_build_status = HudsonBuildStatus.get(params[:id])
    @hudson_build_status.destroy

    respond_to do |format|
      format.html { redirect_to(hudson_build_statuses_url) }
      format.xml  { head :ok }
    end
  end
end
