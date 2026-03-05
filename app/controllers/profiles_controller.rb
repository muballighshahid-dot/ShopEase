class ProfilesController < ApplicationController
  before_action :set_user
  before_action :set_profile, only: [:show, :edit, :update, :destroy]

  def show; end

  def new
    @profile = @user.build_profile
  end

  def create
    @profile = @user.build_profile(profile_params)
    @profile.save ? redirect_to(user_profile_path(@user)) : render(:new, status: :unprocessable_entity)
  end

  def edit; end

  def update
    @profile.update(profile_params) ? redirect_to(user_profile_path(@user)) : render(:edit, status: :unprocessable_entity)
  end

  def destroy
    @profile.destroy
    redirect_to user_path(@user)
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def set_profile
    @profile = @user.profile
    return if @profile.present?

    redirect_to new_user_profile_path(@user), alert: "Create your profile first."
  end

  def profile_params
    params.require(:profile).permit(:bio, :gender, :date_of_birth, :address, :profile_image)
  end
end
