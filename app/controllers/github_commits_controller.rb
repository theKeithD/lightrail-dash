class GithubCommitsController < ApplicationController
  caches_page :index, :show

  # GET /github_commits
  # GET /github_commits.xml
  def index
    @github_commits = GithubCommit.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @github_commits }
    end
  end

  # GET /github_commits/1
  # GET /github_commits/1.xml
  def show
    @github_commit = GithubCommit.get(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @github_commit }
    end
  end

  # GET /github_commits/new
  # GET /github_commits/new.xml
  def new
    expire_page :action => :index
    expire_page :action => :show
    
    @github_commit = GithubCommit.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @github_commit }
    end
  end

  # GET /github_commits/1/edit
  def edit
    expire_page :action => :index
    expire_page :action => :show
    
    @github_commit = GithubCommit.get(params[:id])
  end

  # POST /github_commits
  # POST /github_commits.xml
  def create
    expire_page :action => :index
    expire_page :action => :show
    
    @github_commit = GithubCommit.new(params[:github_commit])

    respond_to do |format|
      if @github_commit.save
        format.html { redirect_to(@github_commit, :notice => 'Github commit was successfully created.') }
        format.xml  { render :xml => @github_commit, :status => :created, :location => @github_commit }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @github_commit.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /github_commits/1
  # PUT /github_commits/1.xml
  def update
    expire_page :action => :index
    expire_page :action => :show
    
    @github_commit = GithubCommit.get(params[:id])

    respond_to do |format|
      if @github_commit.update(params[:github_commit])
        format.html { redirect_to(@github_commit, :notice => 'Github commit was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @github_commit.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /github_commits/1
  # DELETE /github_commits/1.xml
  def destroy
    expire_page :action => :index
    expire_page :action => :show
    
    @github_commit = GithubCommit.get(params[:id])
    @github_commit.destroy

    respond_to do |format|
      format.html { redirect_to(github_commits_url) }
      format.xml  { head :ok }
    end
  end
end
