class Article < ActiveRecord::Base
	has_many :comments
	belongs_to :author
	belongs_to :category
	validates :title, presence: true, length: {minimum: 5, maximum: 50}
	validates :author_id, :presence => true

	def to_s
       "Title: #{title}, created at: #{created_at}, author: #{author}"
    end
end
