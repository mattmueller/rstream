class GoogleReaderShare < Activity
  
  def self.get_historic_shares
    response = HTTParty.get("http://www.google.com/reader/public/atom/user/#{Settings.accounts.google_reader.user_id}/state/com.google/broadcast?n=5000")
    results = []
    unless response['feed']['entry'].empty?
      response['feed']['entry'].each do |entry|
        results << Hashie::Mash.new(entry)
      end
    end
    unless results.empty?
      results.each do |result|
        unless GoogleReaderShare.exists?(:external_id => result['id'].gsub('tag:google.com,2005:reader/item/',''))
          GoogleReaderShare.log_activity(result)
        end
      end
    end
  end

  def self.get_new_shares
    response = HTTParty.get("http://www.google.com/reader/public/atom/user/#{Settings.accounts.google_reader.user_id}/state/com.google/broadcast?n=25")
    results = []
    unless response['feed']['entry'].empty?
      response['feed']['entry'].each do |entry|
        results << Hashie::Mash.new(entry)
      end
    end
    unless results.empty?
      results.each do |result|
        unless GoogleReaderShare.exists?(:external_id => result['id'].gsub('tag:google.com,2005:reader/item/',''))
          GoogleReaderShare.log_activity(result)
        end
      end
    end
  end

  def self.log_activity(result)
    if result.link.is_a?(Array)
      usable_link = result.link.first.href
    else
      usable_link = result.link.href
    end
    GoogleReaderShare.create(:external_id => result['id'].gsub('tag:google.com,2005:reader/item/',''), :created_at => Time.parse(result.published), :title => result.title, :content => result.content, :source_url => usable_link, :metadata => { "author" => result.author.name, "categories" => (result.category.collect{|c| c.term} rescue nil) })
  end

  def icon
    "google_reader_icon.png"
  end
  
end
