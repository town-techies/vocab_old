class CreateAnswers < ActiveRecord::Migration
  def change
    create_table :answers do |t|

      t.timestamps
      t.integer :question_id
      t.text :answer
      t.boolean :true
    end
    add_index :answers,:question_id
  end
end
