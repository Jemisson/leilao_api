class CategoryFilter
  class << self
    def retrieve_all(params = {})
      scope = Category
              .page(params[:page] || 1)
              .per(params[:per_page] || 10)
      scope = scope.where('title ILIKE ?', "%#{params[:title]}%") if params[:title].present?
      scope = scope.where('description ILIKE ?', "%#{params[:description]}%") if params[:description].present?
      scope
    end

    def search(id)
      Category.find(id)
    end
  end
end
