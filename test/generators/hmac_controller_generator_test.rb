require 'test_helper'
require 'generators/shopify_app/hmac_controller/hmac_controller_generator'

class HmacControllerGeneratorTest < Rails::Generators::TestCase
  tests ShopifyApp::Generators::HmacControllerGenerator
  destination File.expand_path("../tmp", File.dirname(__FILE__))

  test "creates the hmac verification controller" do
    run_generator
    assert_file "app/controllers/hmac_verification_controller.rb"
  end
end
