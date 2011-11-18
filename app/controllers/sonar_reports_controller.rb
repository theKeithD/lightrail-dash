class SonarReportsController < ApplicationController
  caches_page :index, :show

  # GET /sonar_reports
  # GET /sonar_reports.xml
  def index
    @sonar_reports = SonarReport.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @sonar_reports }
    end
  end

  # GET /sonar_reports/1
  # GET /sonar_reports/1.xml
  def show
    @sonar_report = SonarReport.get(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @sonar_report }
    end
  end

  # GET /sonar_reports/new
  # GET /sonar_reports/new.xml
  def new
    expire_page :action => :index
    expire_page :action => :show
    
    @sonar_report = SonarReport.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @sonar_report }
    end
  end

  # GET /sonar_reports/1/edit
  def edit
    expire_page :action => :index
    expire_page :action => :show
    
    @sonar_report = SonarReport.get(params[:id])
  end

  # POST /sonar_reports
  # POST /sonar_reports.xml
  def create
    expire_page :action => :index
    expire_page :action => :show
    
    @sonar_report = SonarReport.new(params[:sonar_report])

    respond_to do |format|
      if @sonar_report.save
        format.html { redirect_to(@sonar_report, :notice => 'Sonar report was successfully created.') }
        format.xml  { render :xml => @sonar_report, :status => :created, :location => @sonar_report }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @sonar_report.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /sonar_reports/1
  # PUT /sonar_reports/1.xml
  def update
    expire_page :action => :index
    expire_page :action => :show
    
    @sonar_report = SonarReport.get(params[:id])

    respond_to do |format|
      if @sonar_report.update(params[:sonar_report])
        format.html { redirect_to(@sonar_report, :notice => 'Sonar report was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @sonar_report.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /sonar_reports/1
  # DELETE /sonar_reports/1.xml
  def destroy
    expire_page :action => :index
    expire_page :action => :show
    
    @sonar_report = SonarReport.get(params[:id])
    @sonar_report.destroy

    respond_to do |format|
      format.html { redirect_to(sonar_reports_url) }
      format.xml  { head :ok }
    end
  end
end
