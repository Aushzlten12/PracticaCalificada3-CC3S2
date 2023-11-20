class MoviesController < ApplicationController
  helper_method :sort_column, :sort_direction, :toggle_direction, :hash_ratings
  before_action :save_session_params, only: [:index]
  def show
    id = params[:id]
    @movie = Movie.find(id)
  end

  def index
    @all_ratings = Movie.all_ratings
    @ratings_to_show = params[:ratings] || @all_ratings

    if @ratings_to_show.is_a?(Hash)
      @ratings_to_show = @ratings_to_show.keys
    end

    @movies = Movie.with_ratings(@ratings_to_show)

    if params[:sort].present?
      column_select = sort_column
      direction_select = params[:direction]
      if Movie.column_names.include?(params[:sort]) && ["asc", "desc"].include?(params[:direction])
        @movies = @movies.order("#{column_select} #{direction_select}")
      end
      set_style_header column_select
    end

    session[:ratings] = @ratings_to_show
  end

  def new
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find(params[:id])
  end

  def update
    @movie = Movie.find(params[:id])
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

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def set_style_header(sort_column)
    @title_header_class = 'hilite bg-warning' if sort_column == 'title'
    @release_date_header_class = 'hilite bg-warning' if sort_column == 'release_date'
  end

  def sort_column
    Movie.column_names.include?(params[:sort]) ? params[:sort] : ''
  end

  def toggle_direction(column)
    session["sort_direction_#{column}"] = (session["sort_direction_#{column}"] == 'asc') ? 'desc' : 'asc'
  end

  def hash_ratings(ratings_keys)
    Hash[ratings_keys.map { |ratings_key| [ratings_key, '1'] }]
  end

  def save_session_params
    if params[:sort].nil? && params[:ratings].nil?
      params[:ratings] = hash_ratings(session[:ratings]) if not session[:ratings].nil?
    end
  end

end

