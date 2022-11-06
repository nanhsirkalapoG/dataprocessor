class Product < ApplicationRecord
  belongs_to :user
  has_many :string_custom_fields, as: :customizable, class_name: 'StringCustomField', :dependent => :destroy
  has_many :number_custom_fields, as: :customizable, class_name: 'NumberCustomField', :dependent => :destroy
  has_many :date_custom_fields, as: :customizable, class_name: 'DateCustomField', :dependent => :destroy
end
