class MoviesController < ApplicationController
  before_action :authenticate_user! , only: [:new, :create, :edit, :update, :destroy]
  before_action :find_movie_and_check_permission, only: [:edit, :update, :destroy]
  def index
    @movies = Movie.all
  end

  def show
    @movie = Movie.find(params[:id])
    @reviews = @movie.reviews.recent.paginate(:page => params[:page], :per_page => 5)
  end

  def edit
  end

  def new
    @movie = Movie.new
  end

  def create
    @movie = Movie.new(movie_params)
    @movie.user = current_user
    if @movie.save
      current_user.join!(@movie)
      redirect_to movies_path
    else
      render :new
    end
  end

   def update
     if @movie.update(movie_params)
     redirect_to movies_path, notice: "编辑成功"
   else
     render :edit
   end
 end

   def destroy
     @movie.destroy
     flash[:alert] = "成功删除电影"
     redirect_to movies_path
   end

   def join
     @movie = Movie.find(params[:id])

     if !current_user.is_member_of?(@movie)
       current_user.join!(@movie)
       flash[:notice] = "你已经收藏成功!"
     else
       flash[:warning] = "你已经收藏过了!"
     end

     redirect_to movie_path(@movie)
   end

   def quit
     @movie = Movie.find(params[:id])

     if current_user.is_member_of?(@movie)
       current_user.quit!(@movie)
       flash[:alert] = "你已经取消收藏!"
     else
       flash[:warning] = "你没有收藏,怎么取消 XD"
     end

     redirect_to movie_path(@movie)
   end

   private

   def find_movie_and_check_permission
     @movie = Movie.find(params[:id])

     if current_user != @movie.user
       redirect_to root_path, alert: "你没有权限! "
     end
   end

   def movie_params
     params.require(:movie).permit(:title, :description)
   end

end
