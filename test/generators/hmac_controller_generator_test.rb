require 'test_helper'
require 'generators/shopify_app/hmac_controller/hmac_controller_generator'

class HmacControllerGeneratorTest < Rails::Generators::TestCase
  tests ShopifyApp::Generators::HmacControllerGenerator
  destination File.expand_path("../tmp", File.dirname(__FILE__))

  # setup do
  #   ShopifyApp.configure do |config|
  #     config.embedded_app = true
  #   end

  #   prepare_destination
  #   provide_existing_application_file
  #   provide_existing_routes_file
  #   provide_existing_application_controller
  # end

  test "creates the hmac verification controller" do
    run_generator
    assert_file "app/controllers/hmac_verification_controller.rb"
  end
end
