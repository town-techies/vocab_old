class AddUploadFieldToPuzzle < ActiveRecord::Migration
  def change
    add_column :puzzles, :sound_file_name, :string
    add_column :puzzles, :sound_content_type, :string
    add_column :puzzles, :sound_file_size, :integer
    add_column :puzzles, :sound_updated_at, :datetime
  end
end
