class UsersController < ApplicationController

  def new
    @user = User.friendly.find(params[:user_id])
    @user = User.new
  end

  def edit
    @user = User.friendly.find(params[:id])
    authorize @user
    # flash[:danger] = "You're not authorized"
    # redirect_to root_path
  end

  def create
    @user = User.new(user_params)

    if @user.save
      flash[:success] = "You've created a new account."
      redirect_to root_path
    else
      flash[:danger] = @user.errors.full_messages
      render :new
    end

  end

  def update
    @user = User.friendly.find(params[:id])
    authorize @user
    if @user.update(user_params)
      redirect_to users_path(@user)
    else
      redirect_to edit_user_path(@user)
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :username, :image)
  end

end
