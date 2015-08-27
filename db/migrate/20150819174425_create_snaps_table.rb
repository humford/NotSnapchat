class CreateSnapsTable < ActiveRecord::Migration
	def up
		create_table :snaps do |table|
			table.string :from
			table.string :to
			table.string :filepath
			table.string :mime
			table.datetime :time_sent
			table.boolean :opened
		end
	end

	def down
		drop_table :snaps
	end
end
