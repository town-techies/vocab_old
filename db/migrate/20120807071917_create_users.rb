class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|

      t.timestamps
      t.string :deviceId
      t.string :device_name
      t.boolean :paid
    end
  end
end
