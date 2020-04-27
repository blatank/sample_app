class UsersController < ApplicationController
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
  
  private
    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
end
