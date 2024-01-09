class Order < ApplicationRecord
  validates :price, :quantity, :order_type, :status, presence: true

  belongs_to :user

  enum :order_type, { buy: 0, sell: 1 }
  enum :status, { pending: 0, completed: 1, completed: 2 }
end
