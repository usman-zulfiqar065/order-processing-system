class User < ApplicationRecord
  validates :name, presence: true

  has_many :orders

  def total_quantity_of_completed_orders
    orders.completed.sum(:quantity)
  end
end
