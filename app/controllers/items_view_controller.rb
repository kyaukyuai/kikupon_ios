class ItemsViewController < UIViewController
        def viewDidLoad
                super

                @feed  = nil
                @index = 0

                self.view.backgroundColor = UIColor.greenColor
                self.title = "きくぽん"
                ApplicationUser.load
                user = ApplicationUser.sharedUser
                right_button = UIBarButtonItem.alloc.initWithTitle('設定', style: UIBarButtonItemStylePlain, target:self, action:'push')
                self.navigationItem.rightBarButtonItem = right_button

                self.load
                
                @left_swipe = view.when_swiped do
                        self.push
                end
                @left_swipe.direction = UISwipeGestureRecognizerDirectionLeft

                @right_swipe = view.when_swiped do
                        self.pull
                end
                @right_swipe.direction = UISwipeGestureRecognizerDirectionRight

                @down_swipe = view.when_swiped do
                        self.reload
                end
                @down_swipe.direction = UISwipeGestureRecognizerDirectionDown
        end
        
        def load
                geo_info = GeoInfo.new
                geo_info.load
                request_url = 'http://kikupon-api.herokuapp.com/s/v1/get_rests?id=1234&lat=' + geo_info.lat.to_s + '&lng=' + geo_info.lng.to_s

                BW::HTTP.get(request_url) do |response|
                        if response.ok?
                                @feed = BW::JSON.parse(response.body.to_str)
                                self.write_view
                        else
                                App.alert(response.error_message)
                        end
                end
        end

        def reload
                @index = 0
                self.remove_view
                self.load
        end

        def show_no_shop
                alert = UIAlertView.new
                alert.message = "あなたにおすすめするレシピは\nもうありません"
                alert.delegate = self
                alert.addButtonWithTitle "了解"
                alert.show
        end

        def push
                if @index < @feed.count - 1
                        @index = @index + 1
                        self.remove_view
                        self.write_view
                else
                        self.show_no_shop
                end
        end

        def pull
                if @index > 0
                        @index = @index - 1
                        self.remove_view
                        self.write_view
                else
                        self.show_no_shop
                end
        end

        def initWithNibName(name, bundle: bundle)
                super
                self.tabBarItem = UITabBarItem.alloc.initWithTabBarSystemItem(UITabBarSystemItemFavorites, tag: 1)
                self
        end

        def write_view
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

        def remove_view
                @label.removeFromSuperview
                @image.removeFromSuperview
                @category.removeFromSuperview
                @budget.removeFromSuperview
                @opentime.removeFromSuperview
        end
end
