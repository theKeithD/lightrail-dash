class JiraIssueSummariesController < ApplicationController
  caches_page :index, :show

  # GET /jira_issue_summaries
  # GET /jira_issue_summaries.xml
  def index
    @jira_issue_summaries = JiraIssueSummary.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @jira_issue_summaries }
    end
  end

  # GET /jira_issue_summaries/1
  # GET /jira_issue_summaries/1.xml
  def show
    @jira_issue_summary = JiraIssueSummary.get(params[:id])
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @jira_issue_summary }
    end
  end

  # GET /jira_issue_summaries/new
  # GET /jira_issue_summaries/new.xml
  def new
    expire_page :action => :index
    expire_page :action => :show
    
    @jira_issue_summary = JiraIssueSummary.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @jira_issue_summary }
    end
  end

  # GET /jira_issue_summaries/1/edit
  def edit
    expire_page :action => :index
    expire_page :action => :show
    
    @jira_issue_summary = JiraIssueSummary.get(params[:id])
  end

  # POST /jira_issue_summaries
  # POST /jira_issue_summaries.xml
  def create
    expire_page :action => :index
    expire_page :action => :show
    
    @jira_issue_summary = JiraIssueSummary.new(params[:jira_issue_summary])

    respond_to do |format|
      if @jira_issue_summary.save
        format.html { redirect_to(@jira_issue_summary, :notice => 'Jira issue summary was successfully created.') }
        format.xml  { render :xml => @jira_issue_summary, :status => :created, :location => @jira_issue_summary }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @jira_issue_summary.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /jira_issue_summaries/1
  # PUT /jira_issue_summaries/1.xml
  def update
    expire_page :action => :index
    expire_page :action => :show
    
    @jira_issue_summary = JiraIssueSummary.get(params[:id])

    respond_to do |format|
      if @jira_issue_summary.update(params[:jira_issue_summary])
        format.html { redirect_to(@jira_issue_summary, :notice => 'Jira issue summary was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @jira_issue_summary.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /jira_issue_summaries/1
  # DELETE /jira_issue_summaries/1.xml
  def destroy
    expire_page :action => :index
    expire_page :action => :show
    
    @jira_issue_summary = JiraIssueSummary.get(params[:id])
    @jira_issue_summary.destroy

    respond_to do |format|
      format.html { redirect_to(jira_issue_summaries_url) }
      format.xml  { head :ok }
    end
  end
end
