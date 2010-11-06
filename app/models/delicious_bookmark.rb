class DeliciousBookmark < Activity
  require 'www/delicious'

  def self.authorize_access
    d = WWW::Delicious.new('username','password')
  end

  def self.get_historic_bookmarks
    client = DeliciousBookmark.authorize_access
    results = client.posts_all rescue []
    results.each do |bookmark|
      unless DeliciousBookmark.exists?(:created_at => bookmark.time.utc)
        DeliciousBookmark.log_activity(bookmark)
      end
    end
  end

  def self.get_new_bookmarks
    client = DeliciousBookmark.authorize_access
    results = client.posts_recent rescue []
    results.each do |bookmark|
      unless DeliciousBookmark.exists?(:created_at => bookmark.time.utc)
        DeliciousBookmark.log_activity(bookmark)
      end
    end
  end   

  def self.log_activity(bookmark)
    DeliciousBookmark.create(:created_at => bookmark.time.utc, :title => bookmark.title, :source_url => bookmark.url.to_s, :metadata => { "tags" => bookmark.tags, "notes" => bookmark.notes })
  end
  
end
