# frozen_string_literal: true

class HomeController < AuthenticatedController
  def index
    @products = ShopifyAPI::Product.find(:all, params: { limit: 10 })
    @webhooks = ShopifyAPI::Webhook.find(:all)
  end

  def show
    Struct.new("Image", :src, :alt) #we will use this to store each Image instance

    @image_array = []

    #get the product by id
    @product = ShopifyAPI::Product.find(params[:id])

    #store the headers for our request
    headers = {"X-Shopify-Access-Token" => @shop_session.token}

    if @product.images.present?
      #loop through each image on the product
      @product.images.each do |image|
        src = image.src
        id = image.id.to_s

        #make the request and store it in a variable
        metafields = HTTParty.get("https://#{@shop_session.domain}/admin/metafields.json?metafield[owner_id]=#{id}&metafield[owner_resource]=product_image", :headers => headers).values.first

        alt = metafields.first.present? ? metafields.first['value'] : @product.title

        image = Struct::Image.new(src, alt)
        @image_array.push(image) #push the image into the images array
      end
    end

  end
end
