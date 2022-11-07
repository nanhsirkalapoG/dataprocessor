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
  has_many :string_custom_fields, as: :customizable, class_name: 'StringCustomField', :dependent => :destroy
  has_many :number_custom_fields, as: :customizable, class_name: 'NumberCustomField', :dependent => :destroy
  has_many :date_custom_fields, as: :customizable, class_name: 'DateCustomField', :dependent => :destroy
end
