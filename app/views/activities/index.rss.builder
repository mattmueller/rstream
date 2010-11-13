xml.instruct! :xml, :version => "1.0" 
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "The Matt Mueller"
    xml.description "Personal Lifestream from Matt Mueller"
    xml.link "http://themattmueller.com"

    for activity in @activities
      xml.item do
        xml.title activity.title
        xml.description activity.content
        xml.pubDate activity.created_at.to_s(:rfc822)
        xml.link activity_url(activity)
        xml.guid activity_url(activity)
      end
    end
  end
end
