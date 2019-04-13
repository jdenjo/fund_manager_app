class Position < ApplicationRecord
  belongs_to :fund
  belongs_to :user
  has_many :transactions, dependent: :nullify
end
