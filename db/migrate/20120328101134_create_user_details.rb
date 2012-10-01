class CreateUserDetails < ActiveRecord::Migration
  def change
    create_table :user_details do |t|
      t.integer :user_id
      t.string :user_answer
      t.string :email
      t.string :mbti_result
      t.string :device_id
      t.string :name

      t.timestamps
    end
  end
end
