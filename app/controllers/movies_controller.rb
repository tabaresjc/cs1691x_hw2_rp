class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
	#session.delete(:sort)
	#session.delete(:ratings)
	@all_ratings = Movie.ratings
	@title_header = ""
	@release_date_header = ""

	@sort_by = params[:sort] || session[:sort] || ""
	@rating_list = params[:ratings] || session[:ratings] || {}

	if(@rating_list.empty?)
		@rating_list = @all_ratings
	end
	@rating_list.each {|k,v| @all_ratings[k] = true }

	if(params[:sort]!=nil)
		@sort_by = params[:sort].to_s;

		if @sort_by == "title"			
			@title_header = "hilite"
		elsif @sort_by=="release_date"
			@release_date_header = "hilite"
		else
			@sort_by = ""
		end
	end

	if params[:sort] != session[:sort] or params[:ratings] != session[:ratings]
		session[:sort] = @sort_by
		session[:ratings] = @rating_list
		flash.keep
		redirect_to :sort => @sort_by, :ratings => @rating_list
	end

	if(@sort_by.empty?)
		@movies = Movie.find_all_by_rating(@rating_list.keys)
	else
		@movies = Movie.order(@sort_by).find_all_by_rating(@rating_list.keys)
	end
  end



  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
