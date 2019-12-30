class Webhooks::ApplicationController < ApplicationController
  protect_from_forgery except: %i[create]
  skip_before_action :authenticate_user!

  SHARED_SECRET = Rails.application.credentials.shopify[:webhook_secret].freeze

  private

  def webhook_verified?(data, hmac_header)
    calculated_hmac = Base64.strict_encode64(OpenSSL::HMAC.digest('sha256', SHARED_SECRET, data))
    ActiveSupport::SecurityUtils.secure_compare(calculated_hmac, hmac_header)
  end
end