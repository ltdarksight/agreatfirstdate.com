class Api::DiscountController < ApplicationController
  before_filter :authenticate_user!

  def index
    if (coupon = Stripe::Coupon.retrieve(params[:code].to_s) rescue nil )
      render :json => { valid: true,
        discount: (coupon.percent_off || coupon.amount_off),
        discount_type: (coupon.percent_off.present? ? 'percent' : 'amount')
      }
    else
      render :json => { valid: false, discount: 0, discount_type: 'percent' }
    end
  end

end
