class ProductSerializer < ActiveModel::Serializer
  def index
  products = Product.page(params[:page]).per(10)

  render json: {
    success: true,
    data: products,
    meta: {
      current_page: products.current_page,
      total_pages: products.total_pages,
      total_count: products.total_count
    }
  }, status: :ok
end
end
