class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_sidebar_totals

  def set_sidebar_totals
    @stream_count = Activity.count
    @twitter_count = TwitterStatus.count
    @foursquare_count = FoursquareCheckin.count
    @google_reader_count = GoogleReaderShare.count
    @flickr_count = FlickrPhoto.count
    @delicious_count = DeliciousBookmark.count
  end
end
