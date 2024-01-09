class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.integer :price, default: 0, null: false
      t.integer :quantity, default: 0, null: false
      t.integer :order_type, default: 0, null: false
      t.integer :status, default: 0, null: false
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
