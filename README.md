# rstream

Create your own lifestream, take control of your data.  Example: http://themattmueller.com

## Requirements

 * Ruby (tested with 1.8.7 and REE)
 * Rails 3
 * MySQL
 * Cron (to poll for updates)

## Assumptions

You use one or more of:

 * Twitter
 * Foursquare
 * del.icio.us
 * Flickr
 * Google Reader

You know how to create an application/get an api key from sites requiring it, authorize your user account, and retrieve the various oauth tokens involved.

## Setup

 * Clone rstream and install gems using bundler:

    git clone git@github.com:mattmueller/rstream.git
    bundle install

 * Copy config/database.yml.example to config/database.yml - modifying with your database credentials, migrate:

    rake db:migrate

 * Copy config/settings.yml.example to config/settings.yml - fill out the various options (leave account credentials blank to ignore it)

 * Run historic polling to go back in time and get as much data from services as possible (may take a while) from the console:

    DeliciousBookmark.get_historic_bookmarks
    FlickrPhoto.get_historic_photos
    FoursquareCheckin.get_historic_checkins
    GoogleReaderShare.get_historic_shares
    TwitterStatus.get_historic_statuses

 * In your crontab, set entries for the services you want to poll and the intervals at which you want to poll them, in this case they are combined into a single bash file that is invoked every 5 minutes:

    #!/bin/bash
    cd /path/to/app/root
    RAILS_ENV=production script/rails runner "DeliciousBookmark.get_new_bookmarks"
    RAILS_ENV=production script/rails runner "FlickrPhoto.get_new_photos"
    RAILS_ENV=production script/rails runner "FoursquareCheckin.get_new_checkins"
    RAILS_ENV=production script/rails runner "GoogleReaderShare.get_new_shares"
    RAILS_ENV=production script/rails runner "TwitterStatus.get_new_statuses"
 

    */5 * * * * sh /path/to/above/script.sh

 * Deploy: obviously if you want this available on the web you'll need to deploy it.

XML and JSON versions of your activities can be accessed at http://yoursite.com/feed.xml and http://yoursite.com/feed.json


## Note on Patches/Pull Requests
 
 * Fork the project.
 * Setup your development environment with: gem install bundler; bundle install
 * Make your feature addition or bug fix.
 * Send me a pull request.


## License

MIT License - See LICENSE for more details.
