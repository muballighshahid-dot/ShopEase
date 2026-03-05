class AddressesController < ApplicationController
  before_action :set_address, only: [:show, :edit, :update, :destroy]

  def index
    @addresses = Address.all
  end

  def show
  end

  def new
    @address = Address.new
  end

  def create
    @address = Address.new(address_params)

    if @address.save
      redirect_to @address, notice: "Address created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @address.update(address_params)
      redirect_to @address, notice: "Address updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @address.destroy
    redirect_to addresses_path, notice: "Address deleted successfully."
  end

  private

  def set_address
    @address = Address.find(params[:id])
  end

  def address_params
    params.require(:address).permit(
      :user_id,
      :street,
      :city,
      :state,
      :country,
      :zip_code
    )
  end
end