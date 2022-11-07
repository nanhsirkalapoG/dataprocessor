# frozen_string_literal: true

# == Schema Information
#
# Table name: products
#
#  id          :bigint           not null, primary key
#  description :string(255)
#  price       :decimal(10, 2)
#  title       :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  external_id :string(255)
#  user_id     :integer
#
class Product < ApplicationRecord
  belongs_to :user

  has_many :custom_fields, as: :customizable, dependent: :destroy

  validates_length_of :custom_fields, maximum: 30
end
