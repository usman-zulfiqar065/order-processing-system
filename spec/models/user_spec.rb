require 'rails_helper'

RSpec.describe User, :type => :model do
  it 'is valid with a name' do
    user = User.new(name: 'John Doe')
    expect(user).to be_valid
  end

  it 'is invalid without a name' do
    user = User.new
    expect(user).to_not be_valid
    expect(user.errors[:name]).to include("can't be blank")
  end

  describe '#total_quantity_of_completed_orders' do
    let(:user) { User.create(name: 'John Doe') }
    it 'calculates the total quantity of completed orders' do
      
      # Create completed orders for the user
      completed_orders = [
        user.orders.create(status: 'completed', quantity: 5),
        user.orders.create(status: 'completed', quantity: 3),
        user.orders.create(status: 'completed', quantity: 2)
      ]

      # Create an incomplete order
      user.orders.create(status: 'pending', quantity: 10)

      # Ensure the method returns the correct total quantity for completed orders
      expect(user.total_quantity_of_completed_orders).to eq(10) # 5 + 3 + 2 = 10
    end

    it 'handles cases with no completed orders' do
      user = User.create(name: 'Jane Doe')

      expect(user.total_quantity_of_completed_orders).to eq(0)
    end
  end
end