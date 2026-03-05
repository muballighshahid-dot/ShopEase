class ReviewsController < ApplicationController
  before_action :set_product
  before_action :set_review, only: [:show, :edit, :update, :destroy]
  before_action :require_customer!, only: [:create]

  def index
    @reviews = @product.reviews.includes(:user).order(created_at: :desc)
  end

  def show
  end

  def new
    @review = @product.reviews.new
  end

  def create
    @review = @product.reviews.new(review_params)
    @review.user = current_user

    if @review.save
      redirect_to product_path(@product), notice: "Review added successfully."
    else
      @reviews = @product.reviews.includes(:user).order(created_at: :desc)
      render "products/show", status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    unless @review.user == current_user || admin_user?
      redirect_to product_path(@product), alert: "Not authorized to update this review."
      return
    end

    if @review.update(review_params.except(:user_id, :product_id))
      redirect_to product_path(@product), notice: "Review updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    unless @review.user == current_user || admin_user?
      redirect_to product_path(@product), alert: "Not authorized to remove this review."
      return
    end

    @review.destroy
    redirect_to product_path(@product), notice: "Review deleted successfully."
  end

  private

  def set_product
    @product = Product.find(params[:product_id])
  end

  def set_review
    @review = @product.reviews.find(params[:id])
  end

  def review_params
    params.require(:review)
          .permit(:user_id, :product_id, :rating, :comment)
  end
end
