class BootstrapBuilder < SimpleForm::FormBuilder
  def input(attribute_name, options={}, &block)
    options[:wrapper_html] ||= {}
    options[:wrapper_html].merge! :class => 'control-group'
    super
  end
end

class ApplicationController < ActionController::Base
  protect_from_forgery
end
