class Fund < ApplicationRecord
  belongs_to :pm, class_name: "User"
  has_many :positions, dependent: :nullify
  has_many :transactions, dependent: :nullify
end
