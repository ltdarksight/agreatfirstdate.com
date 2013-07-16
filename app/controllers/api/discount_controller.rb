class Api::DiscountController < ApplicationController
  before_filter :authenticate_user!

  def index
    if Stripe::Coupons::GOLD20.id.to_s == params[:code].to_s
      render :json => { valid: true, discount: Stripe::Coupons::GOLD20.percent_off, discount_type: 'percent' }
    else
      render :json => { valid: false, discount: 0, discount_type: 'percent' }
    end
  end

end
