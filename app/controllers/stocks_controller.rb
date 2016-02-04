class StocksController < ApplicationController
	
	def search
		if params[:stock]
			#looking for the ticker in db if params[:stock] is valid
			@stock = Stock.find_by_ticker(params[:stock])
			#else if the stock doesn't exist in the database
			@stock ||= Stock.new_from_lookup(params[:stock])
		end
		
		if @stock
			#display what @stock is
#			render json: @stock
			render partial:'lookup'
		else
			render status::not_found, nothing:true
		end
	end
		
end