require "err_supply/view_helpers"

ActionView::Base.module_eval { include ErrSupply::ViewHelpers }  if defined? ActionView