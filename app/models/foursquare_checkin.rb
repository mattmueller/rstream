class FoursquareCheckin < Activity
  
  def self.authorize_access
    oauth = Foursquare::OAuth.new('appcreds')
    oauth.authorize_from_access('usercreds')
    fq = Foursquare::Base.new(oauth)
  end

  def self.get_historic_checkins
    client = FoursquareCheckin.authorize_access
    @max_id = FoursquareCheckin.first(:order => 'created_at desc').external_id rescue nil
    if @max_id.nil?
      checkins = client.history(:sinceid => 1, :l => 250)
    else
      checkins = client.history(:sinceid => @max_id, :l => 250)
    end
    unless checkins.empty?
      checkins.each do |checkin|
        unless FoursquareCheckin.exists?(:external_id => checkin['id'])
          FoursquareCheckin.log_activity(checkin)
        end
      end
      FoursquareCheckin.get_historic_checkins
    end
  end

  def self.get_new_checkins
    client = FoursquareCheckin.authorize_access
    @max_id = FoursquareCheckin.first(:order => 'created_at desc').external_id rescue nil
    if @max_id.nil?
      checkins = client.history(:sinceid => 1, :l => 250)
    else
      checkins = client.history(:sinceid => @max_id, :l => 250)
    end
    unless checkins.empty?
      checkins.each do |checkin|
        unless FoursquareCheckin.exists?(:external_id => checkin['id'])
          FoursquareCheckin.log_activity(checkin)
        end
      end
      FoursquareCheckin.get_historic_checkins
    end
  end

  def self.log_activity(checkin)
    FoursquareCheckin.create(:external_id => checkin['id'], :created_at => checkin.created.to_time.utc, :title => checkin['display'], :content => checkin.shout, :metadata => { "venue_name" => checkin.venue.name, "venue_id" => checkin.venue['id'], "lat" => checkin.venue.geolat, "lon" => checkin.venue.geolong })
  end

end
