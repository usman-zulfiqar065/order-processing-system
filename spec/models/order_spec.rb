require 'rails_helper'

RSpec.describe Order, type: :model do
  let(:user) { User.create(name: 'John Doe') }

  it 'is valid with valid attributes' do
    order = Order.new(
      price: 30,
      quantity: 5,
      order_type: :buy,
      status: :pending,
      user: user
    )
    expect(order).to be_valid
  end

  it 'is invalid without required attributes' do
    order = Order.new
    expect(order).to_not be_valid
  end

  it 'belongs to a user' do
    association = Order.reflect_on_association(:user)
    expect(association.macro).to eq(:belongs_to)
  end

  it 'has correct enums' do
    expect(Order.order_types.keys).to eq(['buy', 'sell'])
    expect(Order.statuses.keys).to eq(['pending', 'completed', 'canceled'])
  end

  it 'has a scope for completed buy orders' do
    completed_buy_orders = [
      Order.create(price: 15, quantity: 2, order_type: :buy, status: :completed, user: user),
      Order.create(price: 25, quantity: 3, order_type: :buy, status: :completed, user: user)
    ]

    Order.create(price: 30, quantity: 4, order_type: :sell, status: :completed, user: user)
    Order.create(price: 20, quantity: 5, order_type: :buy, status: :pending, user: user)

    expect(Order.completed_buy_orders).to match_array(completed_buy_orders)
  end

  describe '#process_order' do
    it 'updates status to completed for a valid buy order' do
      order = Order.create(price: 18, quantity: 3, order_type: :buy, status: :pending, user: user)
      order.process_order
      expect(order.reload.status).to eq('completed')
    end

    it 'updates status to completed for a valid sell order' do
      order = Order.create(price: 45, quantity: 2, order_type: :sell, status: :pending, user: user)
      order.process_order
      expect(order.reload.status).to eq('completed')
    end

    it 'updates status to canceled for an invalid buy order' do
      order = Order.create(price: 25, quantity: 2, order_type: :buy, status: :pending, user: user)
      order.process_order
      expect(order.reload.status).to eq('canceled')
    end

    it 'updates status to canceled for an invalid sell order' do
      order = Order.create(price: 35, quantity: 3, order_type: :sell, status: :pending, user: user)
      order.process_order
      expect(order.reload.status).to eq('canceled')
    end

    it 'logs an error for an exception during order processing' do
      order = Order.create(price: 25, quantity: 4, order_type: :buy, status: :pending, user: user)
      allow(order).to receive(:update).and_raise(StandardError, 'An error occurred')
      expect(Rails.logger).to receive(:error).with(/Error processing order: An error occurred/)
      order.process_order
    end
  end
end