class CreateUsersProfiles < ActiveRecord::Migration
  def change
    create_table :users_profiles do |t|
      t.integer :user_id
      t.integer :question_id
      t.integer :answer_id
      t.integer :mbti_score_id

      t.timestamps
    end
  end
end
