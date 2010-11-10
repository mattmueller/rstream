class ActivitiesController < ApplicationController
  
  def index
    if params[:activity_type].nil?
      @current_tab = 'stream'
      @activities = Activity.all(:order => 'created_at desc', :limit => 20)
    else
      @current_tab = params[:activity_type].underscore
      @activities = Activity.all(:conditions => ["type = ?", params[:activity_type]], :order => 'created_at desc', :limit => 20)
    end
  end

end
