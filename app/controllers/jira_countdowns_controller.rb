class JiraCountdownsController < ApplicationController
  caches_page :index, :show

  # GET /jira_countdowns
  # GET /jira_countdowns.xml
  def index
    @jira_countdowns = JiraCountdown.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @jira_countdowns }
    end
  end

  # GET /jira_countdowns/1
  # GET /jira_countdowns/1.xml
  def show
    @jira_countdown = JiraCountdown.get(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @jira_countdown }
    end
  end

  # GET /jira_countdowns/new
  # GET /jira_countdowns/new.xml
  def new
    expire_page :action => :index
    expire_page :action => :show
    
    @jira_countdown = JiraCountdown.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @jira_countdown }
    end
  end

  # GET /jira_countdowns/1/edit
  def edit
    expire_page :action => :index
    expire_page :action => :show
    
    @jira_countdown = JiraCountdown.get(params[:id])
  end

  # POST /jira_countdowns
  # POST /jira_countdowns.xml
  def create
    expire_page :action => :index
    expire_page :action => :show
    
    @jira_countdown = JiraCountdown.new(params[:jira_countdown])

    respond_to do |format|
      if @jira_countdown.save
        format.html { redirect_to(@jira_countdown, :notice => 'Jira countdown was successfully created.') }
        format.xml  { render :xml => @jira_countdown, :status => :created, :location => @jira_countdown }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @jira_countdown.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /jira_countdowns/1
  # PUT /jira_countdowns/1.xml
  def update
    expire_page :action => :index
    expire_page :action => :show
    
    @jira_countdown = JiraCountdown.get(params[:id])

    respond_to do |format|
      if @jira_countdown.update(params[:jira_countdown])
        format.html { redirect_to(@jira_countdown, :notice => 'Jira countdown was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @jira_countdown.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /jira_countdowns/1
  # DELETE /jira_countdowns/1.xml
  def destroy
    expire_page :action => :index
    expire_page :action => :show
    
    @jira_countdown = JiraCountdown.get(params[:id])
    @jira_countdown.destroy

    respond_to do |format|
      format.html { redirect_to(jira_countdowns_url) }
      format.xml  { head :ok }
    end
  end
end
