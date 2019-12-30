module Webhooks
  module Shopify
    class ProductsController < ApplicationController
      def create
        hmac_header = request.headers['HTTP_X_SHOPIFY_HMAC_SHA256']
        data = request.body.read
        return head 403 if hmac_header.blank? || !webhook_verified?(data, hmac_header)
        paylod = JSON.parse data
        puts paylod
      end
    end
  end
end

