class TwitterStatus < Activity

  validates_presence_of :source_url

  def self.authorize_access
    Twitter::Client.new('hidden')
  end

  def self.get_historic_statuses
    client = TwitterStatus.authorize_access
    @min_id = TwitterStatus.first(:order => 'created_at asc').metadata['status_id']
    if @min_id.nil?
      statuses = client.user_timeline('matt_mueller', :count => 200, :include_rts => 1) rescue nil
      if statuses.nil?
        sleep(60)
        statuses = client.user_timeline('matt_mueller', :count => 200, :include_rts => 1) rescue nil
      end
    else
      statuses = client.user_timeline('matt_mueller', :count => 200, :max_id => @min_id, :include_rts => 1) rescue nil
      if statuses.nil?
        sleep(60)
        statuses = client.user_timeline('matt_mueller', :count => 200, :include_rts => 1) rescue nil
      end
    end
    unless statuses.empty?
      unless statuses.count == 1
        statuses.each do |status|
          unless TwitterStatus.exists?(:external_id => status['id'])
            TwitterStatus.log_activity(status)
          end
        end
        TwitterStatus.get_historic_statuses
      end
    end        
  end

  def self.get_new_statuses
    client = TwitterStatus.authorize_access
    @min_id = TwitterStatus.first(:order => 'created_at desc').external_id
    if @min_id.nil?
      statuses = client.user_timeline('matt_mueller', :count => 200, :include_rts => 1)
    else
      statuses = client.user_timeline('matt_mueller', :include_rts => 1, :since_id => @min_id)
    end
    statuses.each do |status|
      unless TwitterStatus.exists?(:external_id => status['id'])
        TwitterStatus.log_activity(status)
      end
    end
  end

  def self.log_activity(status)
    TwitterStatus.create(:external_id => status['id'], :created_at => status.created_at.to_time.utc, :title => status.text, :metadata => { "lat" => (status.coordinates.coordinates[1] rescue nil), "lon" => (status.coordinates.coordinates[0] rescue nil), "in_reply_to_screen_name" => status.in_reply_to_screen_name, "in_reply_to_status_id" => status.in_reply_to_status_id, "status_id" => "#{status['id']}" }, :source_url => "http://twitter.com/matt_mueller/statuses/#{status['id']}")
  end

end
