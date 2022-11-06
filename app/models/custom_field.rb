class CustomField < ApplicationRecord
  belongs_to :customizable, polymorphic: true
end
