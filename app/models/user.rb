class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
	
	has_many :user_stocks
	has_many :stocks, through: :user_stocks
	
	has_many :friendships
	has_many :friends, through: :friendships
	
	def full_name
		return "#{first_name} #{last_name}".strip if (first_name || last_name)	
		"Anonymous"
	end
	
	#Adding restrictions on number of stocks being tracked
	
	def can_add_stock?(ticker_symbol)
		under_stock_limit? && !stock_already_added?(ticker_symbol)
	end
	
	def under_stock_limit?
		#User is allowed 10 stocks
		(user_stocks.count < 10)
	end
	
	def stock_already_added?(ticker_symbol)
		stock = Stock.find_by_ticker(ticker_symbol)
		#stock wasn't already added
		return false unless stock
		user_stocks.where(stock_id: stock.id).exists?
	end
	
	def not_friends_with?(friend_id)
		#If friend_id doesnt show up at least once on the list of friends, 
		#the the friend and current user are not friends
		friendships.where(friend_id: friend_id).count < 1
	end
	
	def except_current_user(users)
		#Look at each element in users object and REJECTING the one where user id matches the id of the user
		users.reject {|user| user.id == self.id}
	end
	
	#Class-level method
	def self.search(param)
		return User.none if param.blank?
		#if the param is not blank, run the param through a strip & downcase method
		param.strip!
		param.downcase!
		(first_name_matches(param) + last_name_matches(param) + email_matches(param)).uniq
	end
	
	def self.first_name_matches(param)
		matches('first_name', param)
	end
	
	def self.last_name_matches(param)
		matches('last_name', param)
	end
	
	def self.email_matches(param)
		matches('email', param)
	end
	#Method that does the comparison
	def self.matches(field_name, param)
		#using wildcards
		where("lower(#{field_name}) like ?", "%#{param}%")
	end
	
end
