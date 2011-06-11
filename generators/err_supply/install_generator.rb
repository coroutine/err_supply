module ErrSupply
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)

    def generate_javascript
      copy_file "jquery.qtip-1.0.0-rc3.min.js", "public/javascripts/jquery.qtip-1.0.0-rc3.min.js"
      copy_file "err_supply.js",                "public/javascripts/err_supply.js"
    end
  end
end