class VerticalSpacersController < ApplicationController
  caches_page :index, :show

  # GET /vertical_spacers
  # GET /vertical_spacers.xml
  def index
    @vertical_spacers = VerticalSpacer.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @vertical_spacers }
    end
  end

  # GET /vertical_spacers/1
  # GET /vertical_spacers/1.xml
  def show
    @vertical_spacer = VerticalSpacer.get(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @vertical_spacer }
    end
  end

  # GET /vertical_spacers/new
  # GET /vertical_spacers/new.xml
  def new
    expire_page :action => :index
    expire_page :action => :show
    
    @vertical_spacer = VerticalSpacer.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @vertical_spacer }
    end
  end

  # GET /vertical_spacers/1/edit
  def edit
    expire_page :action => :index
    expire_page :action => :show
    
    @vertical_spacer = VerticalSpacer.get(params[:id])
  end

  # POST /vertical_spacers
  # POST /vertical_spacers.xml
  def create
    expire_page :action => :index
    expire_page :action => :show
    
    @vertical_spacer = VerticalSpacer.new(params[:vertical_spacer])

    respond_to do |format|
      if @vertical_spacer.save
        format.html { redirect_to(@vertical_spacer, :notice => 'Vertical spacer was successfully created.') }
        format.xml  { render :xml => @vertical_spacer, :status => :created, :location => @vertical_spacer }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @vertical_spacer.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /vertical_spacers/1
  # PUT /vertical_spacers/1.xml
  def update
    expire_page :action => :index
    expire_page :action => :show
    
    @vertical_spacer = VerticalSpacer.get(params[:id])

    respond_to do |format|
      if @vertical_spacer.update(params[:vertical_spacer])
        format.html { redirect_to(@vertical_spacer, :notice => 'Vertical spacer was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @vertical_spacer.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /vertical_spacers/1
  # DELETE /vertical_spacers/1.xml
  def destroy
    expire_page :action => :index
    expire_page :action => :show
    
    @vertical_spacer = VerticalSpacer.get(params[:id])
    @vertical_spacer.destroy

    respond_to do |format|
      format.html { redirect_to(vertical_spacers_url) }
      format.xml  { head :ok }
    end
  end
end
