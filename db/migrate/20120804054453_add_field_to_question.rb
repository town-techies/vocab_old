class AddFieldToQuestion < ActiveRecord::Migration
  def change
	add_column :questions,:q_number,:integer 
	add_column :questions,:part_of_speech,:string 
	add_column :questions, :example_sentence,:string 
	add_column :questions,:root,:string 
	add_column :questions, :root_language,:string 
	add_column :questions,:etymology_meaning,:string 
	add_column :questions,:actual_definition,:string 
  end
end
