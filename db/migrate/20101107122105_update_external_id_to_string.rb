class UpdateExternalIdToString < ActiveRecord::Migration
  def self.up
    change_column :activities, :external_id, :string
  end

  def self.down
    change_column :activities, :external_id, :integer, :limit => 8
  end
end
