class Movie < ActiveRecord::Base
	def self.ratings
		Hash[Movie.select(:rating).all.map { |x| [x.rating,false] }]	
	end

end
