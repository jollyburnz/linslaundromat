class OrdersController < ApplicationController
  #support an array of credit cards for the gateway
  CARD_TYPES = [ ["Visa", "visa"], ["MasterCard", "master"], ["Discover", "discover"] ]

  before_filter :authenticate, :only => :index

  def new
    @order = Order.new
    @order_items = Product.find(:all).collect {|product| OrderItem.new(:product => product, :order=> @order, :quantity => 0)}
  end

  def create
    if !params[:confirmed]
      get_payment
    else
      process_payment
    end
  end

  def index
    @orders = Order.find(:all, :conditions => ["created_at >= ? AND paid = '1'", 1.day.ago], :order => "created_at DESC")
  end

  private

    def authenticate
      authenticate_or_request_with_http_basic do |username, password|
        username == "admin" && password == "secret"
      end
    end

    def get_payment
      @order = Order.new(params[:order])
      @order_items = params[:order_items].collect { |oi| OrderItem.new(oi) }
      if @order.save
        @order_items.each { |item| @order.order_items << item if item.quantity > 0 }
        render(:action => 'payment')
      else
        render(:action => 'new')
      end
    end

    def process_payment
      @order = Order.find(params[:order_id])
      @credit_card = ActiveMerchant::Billing::CreditCard.new(params[:credit_card])
      if @credit_card.valid?
        gateway = ActiveMerchant::Billing::BraintreeGateway.new(
          :merchant_id => AM_GATEWAY_MERCHANT_ID,
          :public_key => AM_GATEWAY_PUBLIC_KEY,
          :private_key => AM_GATEWAY_PRIVATE_KEY)
        response = gateway.purchase(@order.price, @credit_card, {:order_id => @order.reference_number})
        if response.success? && @order.complete(response)
          render(:action => 'receipt')
        else
          #report errors
          @order.errors.add_to_base(response.message)
          render(:action => 'payment')
        end
      else
        render(:action => 'payment')
      end
    end
end
