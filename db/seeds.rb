# frozen_string_literal: true

admin = User.find_or_initialize_by(email: 'administrador@leiloescapuci.com.br')
admin.assign_attributes(
  password: '2@9e~8JY7mP',
  password_confirmation: '2@9e~8JY7mP',
  role: 'admin'
)
admin.jti ||= SecureRandom.uuid
admin.save!

CatalogSetting.current

%w[Prendas Gado].each do |title|
  Category.find_or_create_by!(title: title)
end
