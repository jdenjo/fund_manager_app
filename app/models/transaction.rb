class Transaction < ApplicationRecord
  belongs_to :position
  belongs_to :fund
  belongs_to :user
  validates :shares, :presence => true
  validates :fund, :presence => true
end
