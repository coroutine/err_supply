require 'err_supply/version'
require 'err_supply/view_helpers'

module ErrSupply
  class Engine < ::Rails::Engine
    
    #-------------------------------------------------------
    # Initialization
    #-------------------------------------------------------
    initializer "err_supply.start" do |app|
      
      # add method to views
      ActionView::Base.module_eval { include ErrSupply::ViewHelpers }  if defined? ActionView
      
    end
    
  end
end