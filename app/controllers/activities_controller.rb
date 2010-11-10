class ActivitiesController < ApplicationController
  
  def index
    @current_tab = 'stream'
    @activities = Activity.all(:order => 'created_at desc', :limit => 20)
  end

end
