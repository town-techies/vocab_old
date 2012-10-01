class Question < ActiveRecord::Base
	belongs_to :puzzle
	has_many :answers
end
