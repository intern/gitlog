class CreateSshes < ActiveRecord::Migration
  def self.up
    create_table :sshes do |t|
      t.string     :title
      t.text       :ssh_key
      t.references :user

      t.timestamps
    end
  end

  def self.down
    drop_table :sshes
  end
end
