class Activity < ActiveRecord::Base
  serialize :metadata, Hash
end
