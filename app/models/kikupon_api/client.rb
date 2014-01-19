module KikuponAPI
  class Client
    BASE_URL = 'http://kikupon-api.herokuapp.com/s/v1/get_rests'

    def self.fetch_recommended_shops(user_id, lat, lng, &block)

      url = BASE_URL + "?id=#{user_id}&lat=#{lat}&lng=#{lng}"

      BW::HTTP.get(url) do |response|
        shops = []
        message = nil
        begin
          if response.ok?
            json = BW::JSON.parse(response.body.to_str)

            shops = json.map {|data| KikuponAPI::Shop.new(data) }
          else
            if response.body.nil?
              message = response.error_message
            else
              json = BW::JSON.parse(response.body.to_str)
              message = json['error']
            end
          end
        rescue => e
          p e
          shops = []
          message = 'Error'
        end
        block.call(shops, message)
      end
    end
  end
end
