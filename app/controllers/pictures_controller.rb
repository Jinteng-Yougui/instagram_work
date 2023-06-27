class PicturesController < ApplicationController
  before_action :set_picture, only: %i[ show edit update destroy ]

  # GET /pictures or /pictures.json
  def index
    @pictures = Picture.all
  end

  # GET /pictures/1 or /pictures/1.json
  def show
    @picture = Picture.find(params[:id])
    @favorite = current_user.favorites.find_by(picture_id: @picture.id)
  end

  # GET /pictures/new
  def new
    @picture = Picture.new
  end

  def confirm
    @picture = current_user.pictures.build(picture_params)
    render :new if @picture.invalid?
      # ApplicationMailer.mailer(@picture).deliver
  end
  
  # POST /pictures or /pictures.json
  def create
    @picture = current_user.pictures.build(picture_params)
    if params[:back]
      render :new
    else
      respond_to do |format|
        if @picture.save
          ConfirmationMailer.confirmation_mail(@picture).deliver
          
          format.html { redirect_to picture_url(@picture), notice: "投稿しました" }
          format.json { render :show, status: :created, location: @picture }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: @picture.errors, status: :unprocessable_entity }
        end
      end
    end
  end
    
    # GET /pictures/1/edit
  def edit
    @picture = Picture.find(params[:id])
    if @picture.user == current_user
        render :edit
    else
      flash[:notice]="権限がありません"
      redirect_to pictures_path  
    end
  end
    # PATCH/PUT /pictures/1 or /pictures/1.json
  def update
    respond_to do |format|
      if @picture.update(picture_params)
        format.html { redirect_to picture_url(@picture), notice: "編集しました" }
        format.json { render :show, status: :ok, location: @picture }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @picture.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pictures/1 or /pictures/1.json
  def destroy
    @picture.destroy
    respond_to do |format|
      format.html { redirect_to pictures_path, notice: "削除しました" }
      format.json { head :no_content }
    end
  end

  def ensure_current_user
    if @current_user.id != params[:id].to_i
      flash[:notice]="権限がありません"
      redirect_to user_path(@user.id)
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
  def set_picture
    @picture = Picture.find(params[:id])
    binding.pry
  end

  # Only allow a list of trusted parameters through.
  def picture_params
    params.require(:picture).permit(:name, :title, :image, :image_cache, :content)
  end

  def set_confirmation
    @confirmation = Confirmation.find(params[:id])
  end

  def confirmation_params
    params.require(:confirmation).permit(:name, :email, :content)
  end
end