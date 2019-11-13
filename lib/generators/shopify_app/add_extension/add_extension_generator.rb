require 'rails/generators/base'

module ShopifyApp
  module Generators
    class AddExtensionGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      class_option :type, type: :string, aliases: "-t", required: true

      def create_hmac_verification_controller
        template 'hmac_verification_controller.rb', 'app/controllers/hmac_verification_controller.rb'
      end

      def create_extension_controller
        return if extension_type_valid?(type)

        template "#{type}_controller.rb", "app/controllers/#{type}_controller.rb"
      end

      def add_routes
        extensions_routes = routes(type)

        routes_string = "\n"
        routes_string += "resource :#{type}, only: #{extensions_routes['actions']} do\n"
        extensions_routes['endpoints'].each do |endpoint|
          routes_string += "  " + endpoint + "\n"
        end
        routes_string += "end\n\n"
        routes_string.indent!(2)

        inject_into_file(
          'config/routes.rb',
          routes_string,
          after: "root :to => 'home#index'\n"
        )
      end

      private

      def type
        options['type']
      end

      def extension_types
        %w(
          marketing_activities
        )
      end

      def extension_type_valid?(type)
        if extension_types.exclude? type
          shell.say "Invalid extension type. Valid extension types are: #{extension_types.join(", ")}.", :red
          return false
        end
        true
      end

      def routes(type)
        {
          "marketing_activities" => {
            "actions" => "[:create, :update]",
            "endpoints" => [
              "patch :resume",
              "patch :pause",
              "patch :delete",
              "post :republish",
              "post :preload_form_data",
              "post :preview",
              "post :errors",
            ]
          }
        }[type]
      end
    end
  end
end
