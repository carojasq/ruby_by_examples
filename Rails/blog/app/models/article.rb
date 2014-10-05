class Article < ActiveRecord::Base
	has_many :comments
	belongs_to :author
	validates :title, presence: true, length: {minimum: 5, maximum: 50}
end
