class CreateActivities < ActiveRecord::Migration
  def self.up
    create_table :activities do |t|
      t.string :type
      t.string :title
      t.text :content
      t.text :metadata
      t.string :source_url

      t.timestamps
    end

    add_index :activities, :type

  end

  def self.down
    drop_table :activities
  end
end
