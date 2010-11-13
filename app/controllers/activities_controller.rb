class ActivitiesController < ApplicationController
  
  def index
    if params[:activity_type].nil?
      @current_tab = 'stream'
      @activities = Activity.all(:order => 'created_at desc').paginate(:page => params[:page], :per_page => 50)
      @graph_url = Activity.build_graph_url
    else
      @current_tab = params[:activity_type].underscore
      @activities = Activity.all(:conditions => ["type = ?", params[:activity_type]], :order => 'created_at desc').paginate(:page => params[:page], :per_page => 50)
      @graph_url = Activity.build_graph_url(params[:activity_type])
    end
    respond_to do |format|
      format.html
      format.xml { render :xml => @activities }
      format.json { render :json => @activities }
      format.rss { render :rss => @activities }
    end
  end

  def show
    @activity = Activity.find(params[:id])
    respond_to do |format|
      format.html
      format.xml { render :xml => @activity }
      format.json { render :json => @activity }
      format.rss { render :rss => @activity }
    end
  end

end
