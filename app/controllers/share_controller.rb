class ShareController < ActionController::Base
  def product
    @product = Product.find(params[:id])
    render layout: false
  end
end
