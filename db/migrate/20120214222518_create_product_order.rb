class CreateProductOrder < ActiveRecord::Migration
  def self.up
    create_table :products do |t|
      t.string   :name
      t.text     :description
      t.integer  :price, :default => 0
    end

    create_table :orders do |t|
      t.string    :email
      t.string    :bill_firstname
      t.string    :bill_lastname
      t.string    :bill_address
      t.string    :bill_aptnumber
      t.string    :bill_city
      t.integer   :bill_state
      t.string    :bill_zipcode
      t.string    :ship_firstname
      t.string    :ship_lastname
      t.string    :ship_address
      t.string    :ship_aptnumber
      t.string    :ship_city
      t.integer   :ship_state
      t.string    :ship_zipcode
      t.string    :authorization
      t.boolean   :paid, :default => false
      t.timestamps
    end

    create_table :order_items do |t|
      t.integer  :order_id
      t.integer  :product_id
      t.integer  :quantity, :default => 0
    end

  end

  def self.down
    drop_table :order_items
    drop_table :orders
    drop_table :products
  end
end
