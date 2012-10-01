class CreateQuestions < ActiveRecord::Migration
  def change
    create_table :questions do |t|

      t.timestamps
      t.integer :puzzle_id
      t.string :word
     # t.string :text
    end
    add_index :questions,:puzzle_id
  end
end
