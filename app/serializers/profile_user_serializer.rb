# frozen_string_literal: true

class ProfileUserSerializer
  include JSONAPI::Serializer
  attributes :id, :name, :cpf, :birth, :street, :number, :neighborhood, :city, :state, :country, :zip_code

  attribute :user_email do |object|
    object.user.email
  end
end
