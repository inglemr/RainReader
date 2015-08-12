class UsersController < ApplicationController

  before_action :correct_user, only: [:edit, :update, :show]
  before_action :logged_in_user, only: [:destory, :index,:edit, :update, :show]
  before_action :admin_user, only: [:destroy, :index, :show]

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  def index
    @users = User.paginate(page: params[:page])
  end

  def new
  	@user = User.new
  end

  def show
  	@user = User.find(params[:id])
  end

  def create
  	@user = User.new(user_params)
  	if @user.save
      log_in @user
  		flash[:success] = "Welcome to RAIN Reader!"
  			redirect_to @user
  	else
  		render 'new'
  	end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:succes] = "Profile Updated"
      redirect_to @user
    else
      render 'edit'
    end
  end


  private

  	def user_params
  		params.require(:user).permit(:name, :email,:password,:password_confirmation, :gswid, :gswpin)
  	end

    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in"
        redirect_to login_url
      end
    end

    def correct_user
      @user = User.find_by(id: params[:id])
      if !current_user.nil?
        admin = current_user.admin?
      else
        admin = false
      end
      #@user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user) || admin
    end

    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end

end
