class OrderItem < ActiveRecord::Base
  validates_presence_of :order_id, :product_id, :quantity
  validates_inclusion_of :quantity, :in => 1..100

  belongs_to :product
  belongs_to :order

  def price
    quantity * product.price
  end
end
