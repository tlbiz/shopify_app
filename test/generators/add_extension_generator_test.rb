require 'test_helper'
require 'generators/shopify_app/add_extension/add_extension_generator'

class AddExtensionGeneratorTest < Rails::Generators::TestCase
  tests ShopifyApp::Generators::AddExtensionGenerator
  destination File.expand_path("../tmp", File.dirname(__FILE__))
  arguments %w(-t marketing_activities)

  test "fails when invalid extension type is provided" do
    run_generator %w(-t invalid_type)

    assert_no_file "app/controllers/hmac_verification_controller.rb"
  end

  test "adds the respective extension controller" do
    provide_existing_routes_file

    run_generator

    assert_file "app/controllers/marketing_activities_controller.rb" do |controller|
      assert_match 'class MarketingActivitiesController < HmacVerificationController', controller
    end
  end

  test "adds the endpoint routes to routes" do
    provide_existing_routes_file

    run_generator

    assert_file "config/routes.rb" do |routes|
      resource_declaration = "resource :marketing_activities, only: [:create, :update] do"
      routes_declarations = <<~EOS
        patch :resume
        patch :pause
        patch :delete
        post :republish
        post :preload_form_data
        post :preview
        post :errors
      EOS
      assert resource_declaration, routes
      assert routes_declarations, routes
    end
  end
end
