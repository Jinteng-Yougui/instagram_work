class UsersController < ApplicationController
  skip_before_action :login_required, only: [:new, :create]
  def index
    @pictures = Picture.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to user_path(@user.id)
    else
      render :new
    end
  end

  def show
    @user = User.find(params[:id])
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to users_path, notice: "プロフィールを編集しました！"
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :image,:image_cache, :password,
                                 :password_confirmation)
  end
end
