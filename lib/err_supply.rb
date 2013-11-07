require 'err_supply/version'
require 'err_supply/controller_helpers'
require 'err_supply/view_helpers'

module ErrSupply
  class Engine < ::Rails::Engine
    
    #-------------------------------------------------------
    # Initialization
    #-------------------------------------------------------
    initializer "err_supply.start" do |app|
      
      # extend views
      ActiveSupport.on_load :action_view do 
        include ErrSupply::ViewHelpers
      end
      
      # extend controllers
      ActiveSupport.on_load :action_controller do
        include ErrSupply::ControllerHelpers
      end
      
    end
    
  end
end