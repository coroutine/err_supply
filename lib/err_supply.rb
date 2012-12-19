require 'err_supply/version'
require 'err_supply/view_helpers'

module ErrSupply
  class Engine < ::Rails::Engine
    ActionView::Base.module_eval { include ErrSupply::ViewHelpers }  if defined? ActionView
  end
end