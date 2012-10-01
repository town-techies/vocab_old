class Puzzle < ActiveRecord::Base
	has_many :questions
	has_attached_file :sound
end
