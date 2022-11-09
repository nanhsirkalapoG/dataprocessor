# == Schema Information
#
# Table name: users
#
#  id              :bigint           not null, primary key
#  email           :string(255)
#  first_name      :string(255)
#  last_name       :string(255)
#  password_digest :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class User < ApplicationRecord
  has_secure_password

  validates :first_name, presence: true, null: false
  validates :last_name, presence: true, null: false
  validates :email, presence: true, uniqueness: true, null: false

  has_many :products
end
