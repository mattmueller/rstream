class Activity < ActiveRecord::Base
  serialize :metadata, Hash

  validates_presence_of :title
  validates_presence_of :type

end
