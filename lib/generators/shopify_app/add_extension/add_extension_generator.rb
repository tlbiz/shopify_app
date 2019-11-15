require 'rails/generators/base'

module ShopifyApp
  module Generators
    class AddExtensionGenerator < Rails::Generators::Base
      source_root File.expand_path('../templates', __FILE__)

      class_option :type, type: :string, aliases: "-t", required: true

      def generate_app_extension
        return unless extension_type_valid?
        generate "hmac_controller"

        template "#{type}_controller.rb", "app/controllers/#{type}_controller.rb"
        generate_routes
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

      def extension_type_valid?
        if extension_types.exclude? type
          shell.say "Invalid extension type. Valid extension types are: #{extension_types.join(", ")}.", :red
          return false
        end
        true
      end

      def generate_routes
        inject_into_file(
          'config/routes.rb',
          optimize_indentation(routes, 2),
          after: "root :to => 'home#index'\n"
        )
      end

      def routes
        marketing_activities_routes = <<~EOS
          \nresource :marketing_activities, only: [:create, :update] do
            patch :resume
            patch :pause
            patch :delete
            post :republish
            post :preload_form_data
            post :preview
            post :errors
          end
        EOS

        {
          "marketing_activities" => marketing_activities_routes
        }[type]
      end
    end
  end
end
