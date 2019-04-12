class Transaction < ApplicationRecord
  belongs_to :position
  belongs_to :fund
end
