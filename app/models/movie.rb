class Movie < ActiveRecord::Base
  def self.all_ratings
    return ['G','PG','PG-13','R']
  end
  
  def self.filter_movies(selected)
    to_ret = []
    for i in Movie.all.each
      if selected.include? i.rating
        to_ret = to_ret + [i]
      end
    end
    to_ret
 
end
end
