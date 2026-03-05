class UsersController < ApplicationController
  before_action :authenticate_stub, except: [:index, :show, :login, :login_create]
  before_action :set_user, only: [:show, :edit, :update, :destroy, :promote]
  before_action :authorize_admin_stub, only: [:destroy, :promote]
  after_action  :log_action
  around_action :wrap_transaction, only: [:create]

  def index
    @users = User.all
    render :index
  end

  def show
    @user = User.find(params[:id])
    @products = @user.products

    respond_to do |format|
      format.html
      format.json { render json: @user.as_json(include: :products), status: :ok }
    end
  end

  def new
    @user = User.new
  end

  def login; end

  def login_create
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      session[:user_id] = user.id
      NotificationMailer.login_alert(user).deliver_later
      redirect_to user_path(user), notice: "Logged in successfully."
    else
      flash.now[:alert] = "Invalid email or password"
      render :login, status: :unprocessable_entity
    end
  end
def create
  @user = User.new(user_params)

  respond_to do |format|
    if @user.save
      # send email
      UserMailer.with(user: @user).welcome_email.deliver_later

      format.html { redirect_to user_url(@user), notice: "User was successfully created." }
      format.json { render :show, status: :created, location: @user }
    else
      format.html { render :new, status: :unprocessable_entity }
      format.json { render json: @user.errors, status: :unprocessable_entity }
    end
  end
end

  def update
    begin
      @user.update!(user_params)
      redirect_to @user
    rescue ActiveRecord::RecordInvalid => e
      flash[:error] = e.message
      render :edit, status: :unprocessable_entity
    end
  end

  def promote
    @user.update_column(:role, "admin") # bypass validations
    redirect_to @user
  end

  def destroy
    @user.destroy!
    redirect_to users_path
  rescue => e
    flash[:error] = e.message
    redirect_to @user
  end

  private

  def authenticate_stub; true; end
  def authorize_admin_stub; true; end

  def set_user
    @user = User.find(params[:id])
  end

  def log_action
    Rails.logger.info "HTML #{controller_name}##{action_name}"
  end

  def wrap_transaction
    ActiveRecord::Base.transaction { yield }
  end

  def user_params
    params.require(:user)
          .permit(:name, :email, :password, :phone, :role, :avatar)
  end
end
