class ActivitiesController < ApplicationController
  
  def index
    @current_tab = 'stream'
    @activities = FoursquareCheckin.all(:order => 'created_at desc', :limit => 20)
  end

end
