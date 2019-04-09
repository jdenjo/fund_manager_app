class Fund < ApplicationRecord
  belongs_to :pm, class_name: "User"
  has_many :positions, dependent: :destroy
end
