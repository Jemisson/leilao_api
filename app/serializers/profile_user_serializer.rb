# frozen_string_literal: true

class ProfileUserSerializer
  include JSONAPI::Serializer
  attributes :id, :name, :cpf, :birth, :street, :number, :neighborhood, :city, :state, :country, :zip_code, :phone

  attribute :user_attributes do |object|
    {
      id: object.user.id,
      email: object.user.email,
      role: object.user.role
    }
  end
end
