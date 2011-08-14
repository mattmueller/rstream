class FoursquareCheckin < Activity
  
  def self.authorize_access
    client = Foursquare2::Client.new(:oauth_token => Settings.accounts.foursquare.access_secret)
  end

  def self.get_historic_checkins
    client = FoursquareCheckin.authorize_access
    user = client.user('self')
    @max_checkin = FoursquareCheckin.first(:order => 'created_at desc')
    if @max_checkin.nil?
      checkins = client.user_checkins(:afterTimestamp => 1155554215, :l => 250)
    else
      checkins = client.user_checkins(:afterTimestamp => @max_checkin.created_at.to_i, :l => 250)
    end
    unless checkins.items.empty?
      checkins.items.each do |checkin|
        unless FoursquareCheckin.exists?(:external_id => checkin['id'])
          FoursquareCheckin.log_activity(checkin, user)
        end
      end
      FoursquareCheckin.get_historic_checkins
    end
  end

  def self.get_new_checkins
    client = FoursquareCheckin.authorize_access
    user = client.user('self')
    @max_checkin = FoursquareCheckin.first(:order => 'created_at desc')
    if @max_checkin.nil?
      checkins = client.user_checkins(:afterTimestamp => 1155554215, :l => 250)
    else
      checkins = client.user_checkins(:afterTimestamp => @max_checkin.created_at.to_i, :l => 250)
    end
    unless checkins.items.empty?
      checkins.items.each do |checkin|
        unless FoursquareCheckin.exists?(:external_id => checkin['id'])
          FoursquareCheckin.log_activity(checkin, user)
        end
      end
    end
  end

  def self.log_activity(checkin, user)
    FoursquareCheckin.create(:external_id => checkin['id'], :created_at => Time.at(checkin.createdAt).utc, :title => "#{user.firstName} #{user.lastName} @ #{checkin.venue.name}", :content => checkin.shout, :metadata => { "venue_name" => checkin.venue.name, "venue_id" => checkin.venue['id'], "lat" => checkin.venue.location.lat, "lon" => checkin.venue.location.lng })
  end

  def icon
    "foursquare_icon.png"
  end

end
