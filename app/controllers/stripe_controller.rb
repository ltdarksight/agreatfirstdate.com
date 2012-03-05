class StripeController < ApplicationController
  def web_hook
    #customer.created - object[:id]
    #customer.deleted
    #customer.subscription.created- object[:customer]
    #customer.subscription.deleted
    #invoice.created - object[:customer]
    #invoice.payment_succeeded - object[:customer]
    #invoice.payment_failed

    object = params[:data][:object]
    type = params[:type]
    status = case type
    when 'customer.created', 'customer.deleted'
      @profile = Profile.find_by_stripe_customer_token(object[:id])
      'customer.created' == type
    when 'customer.subscription.created', 'customer.subscription.deleted'
      @profile = Profile.find_by_stripe_customer_token(object[:customer])
      'customer.subscription.created' == type
    when 'invoice.created', 'invoice.payment_failed', 'invoice.payment_succeeded'
      @profile = Profile.find_by_stripe_customer_token(object[:customer])
      type != 'invoice.payment_failed'
    else
      logger.debug "Unknown type: #{type}"
      logger.debug object
    end

    if @profile
      @profile.update_attribute(type.split('.').slice(0..-2).push('status').join('_'), status)
    end

    render nothing: true
  end
end