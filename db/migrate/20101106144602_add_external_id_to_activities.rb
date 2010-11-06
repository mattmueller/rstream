class AddExternalIdToActivities < ActiveRecord::Migration
  def self.up
    add_column :activities, :external_id, :integer, :limit => 8
  end

  def self.down
    remove_column :activities, :external_id
  end
end
