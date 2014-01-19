module KikuponAPI
  class Shop
    attr_accessor :name, :latitude, :longtitude, :category, :url, :image_url, :address, :tel, :opentime, :holiday, :budget
    def initialize(data)
      @name      = data['name'] ? data['name'] : '名無し店舗さん'
      @lat       = data['latitude'] ? data['latitude'] : nil
      @lng       = data['longtitude'] ? data['longtitude'] : nil
      @category  = data['category'] ? data['category'] : 'カテゴリーなし'
      @url       = data['url'] ? data['url'] : nil
      @image_url = data['image_url'][0]['shop_image1'] ? data['image_url'][0]['shop_image1'] : nil
      @address   = data['address'] ? data['address'] : nil
      @tel       = data['tel'] ? data['tel'] : nil
      @opentime  = data['opentime'] ? data['opentime'] : nil
      @holiday   = data['holiday'] ? data['holiday'] : nil
      @budget    = data['budget'] ? data['budget'] : nil
    end
  end
end
