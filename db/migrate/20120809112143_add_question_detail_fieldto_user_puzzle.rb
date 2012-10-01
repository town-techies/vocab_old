class AddQuestionDetailFieldtoUserPuzzle < ActiveRecord::Migration
  def up
	add_column :user_puzzles,:question_detail,:string
  end

  def down
	remove_column :user_puzzles,:question_detail
  end
end
