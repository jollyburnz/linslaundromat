class Order < ActiveRecord::Base
  validates_presence_of :email, :bill_firstname, :bill_lastname, :bill_address, :bill_city, :bill_state, :bill_zipcode, :ship_firstname, :ship_lastname, :ship_address, :ship_city, :ship_state, :ship_zipcode

  has_many :order_items, :dependent => :destroy
  has_many :products, :through => :order_items

  attr_protected :paid, :authorization

  def price
    self.order_items.inject(0) { |sum, item| sum += item.price }
  end

  def reference_number
    "C#{self.created_at.strftime("%w%S")}#{self.id}"
  end

  def complete(gateway_response)
    if gateway_response.success?
      self.paid = true
      self.authorization = gateway_response.authorization
      self.save
    else
      false
    end
  end

  def summary
    self.order_items.collect {|item| "#{item.quantity} x #{item.product.name}"}
  end
end
