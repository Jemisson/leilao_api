class CategoryService
  class << self
    def create_category(params)
      Category.create(params)
    end

    def update_category(params, category)
      category.update(params)
    end

    def destroy_category(category)
      category.destroy
    end
  end
end
