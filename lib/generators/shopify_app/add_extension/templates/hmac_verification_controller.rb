# frozen_string_literal: true

class HmacVerificationController < ApplicationController
  protect_from_forgery with: :null_session

  before_action :verify_request

  private

  def verify_request
    hmac_header = request.headers['HTTP_X_SHOPIFY_HMAC_SHA256']
    request_body = request.body.read
    secret = Settings.shopify_client_api_secret
    digest = OpenSSL::Digest.new('sha256')

    calculated_hmac = Base64.strict_encode64(OpenSSL::HMAC.digest(digest, secret, request_body))
    head(:unauthorized) unless calculated_hmac == hmac_header
  end
end
