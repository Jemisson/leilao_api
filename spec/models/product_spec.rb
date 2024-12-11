# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Product, type: :model do
  subject { build(:product) }

  describe 'Validations' do
    it 'is valid with valid attributes' do
      expect(subject).to be_valid
    end

    it 'is not valid without a lot_number' do
      subject.lot_number = nil
      expect(subject).not_to be_valid
      expect(subject.errors[:lot_number]).to include("can't be blank")
    end

    it 'is not valid without a description' do
      subject.description = nil
      expect(subject).not_to be_valid
      expect(subject.errors[:description]).to include("can't be blank")
    end

    it 'is valid without bidder_name, bidder_phone, or winning_value' do
      subject.bidder_name = nil
      subject.bidder_phone = nil
      subject.winning_value = nil
      expect(subject).to be_valid
    end
  end
end
