class CreateCandidates < ActiveRecord::Migration
  def self.up
    create_table :candidates do |t|
      t.string :name
      t.string :contact
      t.boolean :ruby_course
      t.boolean :rails_course

      t.timestamps
    end
  end

  def self.down
    drop_table :candidates
  end
end
