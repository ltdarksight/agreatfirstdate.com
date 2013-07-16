# This file contains descriptions of all your stripe plans

# Example
# Stripe::Plans::PRIMO #=> 'primo'

Stripe.plan :first_plan do |plan|
  #
  #   # plan name as it will appear on credit card statements
  plan.name = 'First plan'
  #
  #   # amount in cents. This is 6.99
  plan.amount = 2000
  #
  #   # interval must be either 'month' or 'year'
  plan.interval = 'month'
  #
  #   # only bill once every three months (default 1)
  #plan.interval_count = 3
  #
  #   # number of days before charging customer's card (default 0)
  #plan.trial_period_days = 30
end

# Once you have your plans defined, you can run
#
#   rake stripe:prepare
#
# This will export any new plans to stripe.com so that you can
# begin using them in your API calls.
