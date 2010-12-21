class CreateProjects < ActiveRecord::Migration
  def self.up
    create_table :projects do |t|
      t.string     :name,       :null => false
      t.string     :location
      t.text       :description
      t.boolean    :protected,  :null => false, :default => 0
      t.references :user

      t.timestamps
    end

    add_index :projects, :name
  end

  def self.down
    drop_table :projects
  end
end
