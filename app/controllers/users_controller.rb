class UsersController < ApplicationController
  before_action :logged_in_user,  only: [:edit, :update, :index, :destroy]
  before_action :correct_user,    only: [:edit, :update]
  before_action :admin_user,      only: :destroy
  
  # GET /users
  def index
    @users = User.paginate(page: params[:page])
  end
  
  # Get /users/new
  def new
    @user = User.new
  end
  
  # Get /users/:id
  def show
    @user = User.find(params[:id])
  end
  
  # POST /users
  def create
    @user = User.create(user_params)
    if @user.save
      log_in @user
      flash[:success] = "Welcome to the Smaple App!"
      redirect_to @user
    else
      render 'new'
    end
    
  end
  
  # GET /users/:id/edit
  def edit
    @user = User.find(params[:id])
  end
    
  # PATCH /users/:id
  def update
    @user = User.find(params[:id])
    
    if @user.update(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
    
  end
  
  # DELETE /users/:id
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end
  
  private
    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
    
    def logged_in_user
      unless logged_in?
        # リクエストしていたURL保存
        store_location
        
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end
    
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user? @user
    end
    
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end      
end
