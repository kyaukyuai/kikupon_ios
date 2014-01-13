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

                BW::HTTP.get('http://recipe4u.herokuapp.com/search.json?service=rakuten&keyword=tomato') do |response|
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
        end
        
        def push
                @label.removeFromSuperview
                @image.removeFromSuperview
                if @index < 2
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

        def initWithNibName(name, bundle: bundle)
                super
                self.tabBarItem = UITabBarItem.alloc.initWithTabBarSystemItem(UITabBarSystemItemFavorites, tag: 1)
                self
        end

        def display_view
                @label = UILabel.alloc.initWithFrame(CGRectZero)
                @label.backgroundColor = UIColor.yellowColor
                @label.text = @feed[:recipes][@index][:recipe][:title]
                @label.sizeToFit
                @label.center = CGPointMake(self.view.frame.size.width / 2, 100)
                self.view.addSubview @label
                
                image_data = NSData.dataWithContentsOfURL(NSURL.URLWithString(@feed[:recipes][@index][:recipe][:image]))
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
