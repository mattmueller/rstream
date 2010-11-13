class FlickrPhoto < Activity
  
  def self.authorize_access
    client = Flickr::Api.new(Settings.accounts.flickr.api_key)
    user = client.users(Settings.accounts.flickr.user_email)
  end

  def self.get_historic_photos
    client = FlickrPhoto.authorize_access
    pages = (1..10).to_a
    pages.each do |page|
      photos = client.photos(:per_page => 500, :page => page)
      unless photos.empty?
        photos.each do |photo|
          unless FlickrPhoto.exists?(:external_id => photo['id'])
            photo.url
            photo.title
            photo.description
            photo.owner
            photo.tags
            FlickrPhoto.log_activity(photo)
          end
        end
      end
    end
  end

  def self.get_new_photos
    client = FlickrPhoto.authorize_access
    photos = client.photos(:per_page => 50)  
    unless photos.empty?
      photos.each do |photo|
        unless FlickrPhoto.exists?(:external_id => photo['id'])
          photo.url
          photo.title
          photo.description
          photo.owner
          photo.tags
          FlickrPhoto.log_activity(photo)
        end
      end
    end
  end

  def self.log_activity(photo)
    FlickrPhoto.create(:external_id => photo['id'], :created_at => Time.at(photo['dates']['posted'].to_i), :title => photo['title'], :source_url => photo.url, :content => photo['description'].to_s, :metadata => { "photo_taken" => photo['dates']['taken'].to_time.utc, "tags" => (photo.tags['tag'].collect{ |t| t['content'] } rescue nil), "lat" => (photo['latitude'] if !photo['latitude'] == '0'), "lon" => (photo['longitude'] if !photo['longitude'] == '0'), "preview_url" => "http://farm#{photo['farm']}.static.flickr.com/#{photo['server']}/#{photo['id']}_#{photo['secret']}.#{photo['originalformat']}" })
  end

  def icon
    "flickr_icon.png"
  end

end
