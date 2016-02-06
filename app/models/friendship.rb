class Friendship < ActiveRecord::Base
	belongs_to :user
	#belong to friend but also to User class
	belongs_to :friend, :class_name => 'User'
end
