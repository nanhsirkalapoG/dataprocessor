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

  validate :valid_custom_fields?

  CUSTOM_FIELDS_LIMIT_BY_TYPE = {
    'date' => 10,
    'number' => 10,
    'string' => 10
  }.freeze

  def valid_custom_fields?
    CUSTOM_FIELDS_LIMIT_BY_TYPE.each do |type, limit|
      if custom_fields.by_data_type(type).size > limit
        errors.add(:custom_fields, "Maximum size(#{limit}) reached for type: #{type}!")
        return false
      end
    end
  end
end
