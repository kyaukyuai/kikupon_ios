class ItemsViewController < UIViewController
        def viewDidLoad
                super

                @feed  = nil
                @index = 0

                self.view.backgroundColor = UIColor.greenColor
                self.title = "きくぽん"
                ApplicationUser.load
                user = ApplicationUser.sharedUser
                right_button = UIBarButtonItem.alloc.initWithTitle(user.user_name, style: UIBarButtonItemStylePlain, target:self, action:'push')
                self.navigationItem.rightBarButtonItem = right_button

                # 位置情報取得
                geo_info = GeoInfo.new
                geo_info.load
                lat = geo_info.lat
                lng = geo_info.lng

                BW::HTTP.get('http://kikupon-api.herokuapp.com/s/v1/get_rests?id=1234&lat=' + lat.to_s + '&lng=' + lng.to_s) do |response|
                        if response.ok?
                                @feed = BW::JSON.parse(response.body.to_str)
                                self.display_view
                        else
                                App.alert(response.error_message)
                        end
                end
                
                @left_swipe = view.when_swiped do
                        self.push
                end
                @left_swipe.direction = UISwipeGestureRecognizerDirectionLeft

                @right_swipe = view.when_swiped do
                        self.pull
                end
                @right_swipe.direction = UISwipeGestureRecognizerDirectionRight

                @right_swipe = view.when_swiped do
                        self.pull
                end
                @right_swipe.direction = UISwipeGestureRecognizerDirectionDown
        end
        
        def push
                @label.removeFromSuperview
                @image.removeFromSuperview
                if @index < @feed.count-1
                        @index = @index + 1
                        self.display_view
                else
                        self.display_view
                        alert = UIAlertView.new
                        alert.message = "あなたにおすすめするレシピは\nもうありません"
                        alert.delegate = self
                        alert.addButtonWithTitle "了解"
                        alert.show
                end
        end

        def pull
                @label.removeFromSuperview
                @image.removeFromSuperview
                if @index > 0
                        @index = @index - 1
                        self.display_view
                else
                        self.display_view
                        alert = UIAlertView.new
                        alert.message = "あなたにおすすめするレシピは\nもうありません"
                        alert.delegate = self
                        alert.addButtonWithTitle "了解"
                        alert.show
                end
        end

        def initWithNibName(name, bundle: bundle)
                super
                self.tabBarItem = UITabBarItem.alloc.initWithTabBarSystemItem(UITabBarSystemItemFavorites, tag: 1)
                self
        end

        def display_view
                @label = UILabel.alloc.initWithFrame(CGRectZero)
                @label.backgroundColor = UIColor.yellowColor
                @label.text = @feed[@index][:name]
                @label.sizeToFit
                @label.center = CGPointMake(self.view.frame.size.width / 2, 100)
                self.view.addSubview @label
                
                @category = UILabel.alloc.initWithFrame(CGRectZero)
                @category.backgroundColor = UIColor.yellowColor
                @category.text = @feed[@index][:category]
                @category.sizeToFit
                @category.center = CGPointMake(self.view.frame.size.width / 2, 130)
                self.view.addSubview @category

                @opentime = UILabel.alloc.initWithFrame(CGRectZero)
                @opentime.backgroundColor = UIColor.yellowColor
                @opentime.text = @feed[@index][:opentime]
                @opentime.sizeToFit
                @opentime.center = CGPointMake(self.view.frame.size.width / 2, 160)
                self.view.addSubview @opentime

                @budget = UILabel.alloc.initWithFrame(CGRectZero)
                @budget.backgroundColor = UIColor.yellowColor
                @budget.text = "予算:" + @feed[@index][:budget]
                @budget.sizeToFit
                @budget.center = CGPointMake(self.view.frame.size.width / 2, 190)
                self.view.addSubview @budget

                self.view.addSubview @label
                image_data = NSData.dataWithContentsOfURL(NSURL.URLWithString(@feed[@index][:image_url][0][:shop_image1]))
                @image = UIImageView.alloc.initWithImage(UIImage.imageWithData(image_data))
                @image.center = CGPointMake(self.view.frame.size.width / 2, 225)
                self.view.addSubview @image

                @reserve_shop_button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
                @reserve_shop_button.backgroundColor = UIColor.orangeColor
                @reserve_shop_button.sizeToFit
                @reserve_shop_button.frame = CGRectMake(20, 340, self.view.frame.size.width-40, 50)
                @reserve_shop_button.setTitle("予約する", forState: UIControlStateNormal)
                @reserve_shop_button.tintColor = UIColor.blackColor
                self.view.addSubview @reserve_shop_button

                @go_shop_button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
                @go_shop_button.backgroundColor = UIColor.orangeColor
                @go_shop_button.sizeToFit
                @go_shop_button.frame = CGRectMake(20, 400, self.view.frame.size.width-40, 50)
                @go_shop_button.setTitle("店に行く", forState: UIControlStateNormal)
                @go_shop_button.tintColor = UIColor.blackColor
                self.view.addSubview @go_shop_button

                @other_shop_button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
                @other_shop_button.backgroundColor = UIColor.orangeColor
                @other_shop_button.sizeToFit
                @other_shop_button.frame = CGRectMake(20, 460, self.view.frame.size.width-40, 50)
                @other_shop_button.setTitle("別の店に！", forState: UIControlStateNormal)
                @other_shop_button.tintColor = UIColor.blackColor
                self.view.addSubview @other_shop_button
                @other_shop_button.addTarget(self, action:'push', forControlEvents:UIControlEventTouchUpInside)
        end
end
