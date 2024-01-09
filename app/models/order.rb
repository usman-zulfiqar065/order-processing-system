class Order < ApplicationRecord
  validates :price, :quantity, :order_type, :status, presence: true

  belongs_to :user

  enum :order_type, { buy: 0, sell: 1 }
  enum :status, { pending: 0, completed: 1, canceled: 2 }

  scope :completed_buy_orders, -> { completed.buy }

  PROCESS_ORDER_BUY_THRESHOLD_VALUE = 20
  PROCESS_ORDER_SELL_THRESHOLD_VALUE = 40

  def process_order
    if (buy? && price < PROCESS_ORDER_BUY_THRESHOLD_VALUE) || (sell? && price > PROCESS_ORDER_SELL_THRESHOLD_VALUE)
      update(status: 'completed')
    else
      update(status: 'canceled')
    end
    rescue StandardError => e
      Rails.logger.error("Error processing order: #{e.message}")
  end

end
