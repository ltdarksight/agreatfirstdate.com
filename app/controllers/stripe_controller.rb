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
      'invoice.payment_failed' != type
    else
      logger.debug "Unknown type: #{type}"
      logger.debug object
      render text: "Unknown type: #{type}\nObject: #{object.inspect}" and return
    end

    if @profile
      @profile.update_attribute(type.split('.').slice(0..-2).push('status').join('_'), status)
      render nothing: true, status: :ok
    else
      render json: {errors: "Can't find customer"}, status: :not_found
    end
  end
end