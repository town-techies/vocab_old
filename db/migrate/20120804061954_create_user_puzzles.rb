class CreateUserPuzzles < ActiveRecord::Migration
  def change
    create_table :user_puzzles do |t|
	  	t.string:device_id
		t.integer:puzzle_id
		t.string:score
		t.string:correct_answer
		t.string:wronge_answer

      t.timestamps
    end
  end
end
