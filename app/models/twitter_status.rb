class TwitterStatus < Activity

  def self.authorize_access
    Twitter::Client.new("hiding credentials")
  end

  def self.get_historic_statuses
    TwitterStatus.authorize_access.user_timeline('matt_mueller', :count => 100)
  end

end
