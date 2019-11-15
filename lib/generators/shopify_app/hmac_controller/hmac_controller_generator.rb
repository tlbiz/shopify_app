require 'rails/generators/base'

module ShopifyApp
  module Generators
    class HmacControllerGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      def create_hmac_verification_controller
        template 'hmac_verification_controller.rb', 'app/controllers/hmac_verification_controller.rb'
      end
    end
  end
end
