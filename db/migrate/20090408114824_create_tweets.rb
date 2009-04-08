class CreateTweets < ActiveRecord::Migration
  def self.up
    create_table :tweets do |t|
      t.string :user
      t.integer :user_id
      t.string :text
      t.string :user_image
      t.datetime :posted_at
      t.string :type

      t.timestamps
    end

    add_index :tweets, :user
  end

  def self.down
    drop_table :tweets
  end
end
