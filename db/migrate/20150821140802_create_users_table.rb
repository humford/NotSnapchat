class CreateUsersTable < ActiveRecord::Migration
  def up
    create_table :users do |table|
      table.string :name
    end
  end
 
  def down
    drop_table :users
  end
end
