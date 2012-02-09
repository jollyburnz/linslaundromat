class PricingController < ApplicationController
  def index
  end
  
  def calculator
    @pounds = params[:pounds]
    @prices = 0
    
    if @pounds.to_i <= 10
       @prices = 7
    else
      @prices = 7+(@pounds.to_i-10).to_i*0.6
    end
    
    respond_to do |format|
      format.js
    end
  end

end
