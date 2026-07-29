# frozen_string_literal: true

class CatalogSettingSerializer
  include JSONAPI::Serializer

  attributes :id, :show_product_values
end
