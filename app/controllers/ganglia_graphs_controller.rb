class GangliaGraphsController < ApplicationController
  caches_page :index, :show
  
  # GET /ganglia-graphs
  # GET /ganglia-graphs.xml
  def index
    @ganglia_graphs = GangliaGraph.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @ganglia_graphs }
    end
  end

  # GET /ganglia-graphs/1
  # GET /ganglia-graphs/1.xml
  def show
    @ganglia_graph = GangliaGraph.get(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @ganglia_graph }
    end
  end

  # GET /ganglia-graphs/new
  # GET /ganglia-graphs/new.xml
  def new
    expire_page :action => :index
    expire_page :action => :show
    
    @ganglia_graph = GangliaGraph.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @ganglia_graph }
    end
  end

  # GET /ganglia-graphs/1/edit
  def edit
    expire_page :action => :index
    expire_page :action => :show
    
    @ganglia_graph = GangliaGraph.get(params[:id])
  end

  # POST /ganglia-graphs
  # POST /ganglia-graphs.xml
  def create
    expire_page :action => :index
    expire_page :action => :show
    
    @ganglia_graph = GangliaGraph.new(params[:ganglia_graph])

    respond_to do |format|
      if @ganglia_graph.save
        format.html { redirect_to(@ganglia_graph, :notice => 'Ganglia Graph was successfully created.') }
        format.xml  { render :xml => @ganglia_graph, :status => :created, :location => @ganglia_graph }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @ganglia_graph.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /ganglia-graphs/1
  # PUT /ganglia-graphs/1.xml
  def update
    expire_page :action => :index
    expire_page :action => :show
    
    @ganglia_graph = GangliaGraph.get(params[:id])

    respond_to do |format|
      if @ganglia_graph.update(params[:ganglia_graph])
        format.html { redirect_to(@ganglia_graph, :notice => 'Ganglia Graph was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @ganglia_graph.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /ganglia-graphs/1
  # DELETE /ganglia-graphs/1.xml
  def destroy
    expire_page :action => :index
    expire_page :action => :show
    
    @ganglia_graph = GangliaGraph.get(params[:id])
    @ganglia_graph.destroy

    respond_to do |format|
      format.html { redirect_to(ganglia_graphs_url) }
      format.xml  { head :ok }
    end
  end
  
  # GET /ganglia-graphs/1/data.json
  def data
    @ganglia_uri = GangliaGraph.all(:conditions => { :id => params[:id] }, :fields => [:uri]).first.uri
    
    respond_to do |format|
      format.json # datapoints.json.erb
    end
  end
end
