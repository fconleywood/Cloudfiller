class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy]
  skip_before_action :require_login, only: [:new, :create]
  # GET /users
  # GET /users.json

  # GET /users/1
  # GET /users/1.json
  def show
    @activities = PublicActivity::Activity.order("created_at desc").where("(owner_id = ? AND owner_type = ?) OR (recipient_id = ? AND recipient_type = ?)", current_user, "User", current_user, "User" ).page(params[:page])
    respond_to do |format|
      format.html { }
      format.js {  }
    end

  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
    unless @user.experience.present?
      @user.build_experience
    end
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    @user.points = 5

    respond_to do |format|
      if @user.save
        format.html { redirect_to root_path }
        format.json { render :root, status: :created, location: @user }
        auto_login(@user)
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        @user.create_activity :update, owner: current_user
        format.html { redirect_to @user }
        format.json { render :show, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to root_path }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = current_user
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :lastname, :email, :password, :password_confirmation, experience_attributes:[:job, :education, :knowledge], rating_attributes:[:rating])
    end
end
