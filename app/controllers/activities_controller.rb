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
  end

end
