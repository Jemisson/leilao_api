namespace :db do
  desc 'Popula o banco com categorias de exemplo'
  task populate_categories: :environment do
    categories = %w[Eletrônicos Móveis Veículos Imóveis Colecionáveis]
    categories.each do |category_name|
      Category.find_or_create_by(title: category_name)
    end
    puts 'Categorias criadas com sucesso!'
  end
end
