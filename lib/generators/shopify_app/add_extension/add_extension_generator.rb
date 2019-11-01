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
        if extension_types.exclude? type
          shell.say "Invalid extension type. Valid extension types are: #{extension_types.join(", ")}.", :red
          return
        end

        template "#{type}_controller.rb", "app/controllers/#{type}_controller.rb"
      end

      def add_routes
        routes = routes(type)

        routes_string = "\n"
        routes_string += "resource :#{type}, only: #{routes['actions']} do\n"
        routes['endpoints'].each do |endpoint|
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

      def routes(type)
        {
          "marketing_activities" => {
            "actions" => "[:create, :update]",
            "endpoints" => [
              "patch :resume",
              "patch :resume",
              "patch :pause",
              "patch :delete",
              "post :republish",
              "post :preload_form_data",
              "post :reload_form_data",
              "post :preview",
              "post :type_ahead",
              "post :errors",
              "post 'load_field/type_ahead', to: 'marketing_activities#type_ahead'"
            ]
          }
        }[type]
      end
    end
  end
end
