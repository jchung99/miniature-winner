class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @movies = Movie.all
    @all_ratings = Movie.all_ratings()
    @ratings_to_show = Array.new
    @sorted = params[:sorted]
    @movies = Movie.order(params[:sorted])
    @click_title = "hilite"
    @click_date = "hilite"
    
    if params[:home] == "yes"
      is_home = true
    end
    @ratings_to_show = @all_ratings
    if session[:ratings] != nil
      @ratings_to_show = session[:ratings]
#       redirect_to movies_path(:ratings=> @ratings_to_show, :sorted => "title")
      @movies = Movie.filter_movies(@ratings_to_show)

    end
#     if session[:in_session] =="yes" and !is_home
#       @ratings_to_show = session[:ratings]
#       @sorted = session[:sorted]
# #       redirect_to movies_path(:ratings => @ratings_to_show, :sorted => @sorted, :home => "yes")
#     end
    if params[:click] == "title"
      @click_title = "hilite bg-warning"
    end
    if params[:click] == "date"
      @click_date = "hilite bg-warning"
    end
    if params["ratings"] != nil
      @ratings_to_show = params["ratings"].keys()
      @movies = Movie.filter_movies(@ratings_to_show)
      session[:ratings] = @ratings_to_show
    end
    
    session[:sorted] = params[:sorted]
    session[:in_session] = "yes"
#     if params[:sorted] == 1
#       @movies = Movie.order("title")
#     end
    
    
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
