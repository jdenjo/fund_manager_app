class Fund < ApplicationRecord
  belongs_to :pm, class_name: "User"
  has_many :positions
  has_many :transactions, dependent: :nullify
end
