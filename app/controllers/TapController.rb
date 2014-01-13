class TapController < UIViewController
  def viewDidLoad
    super


    self.view.backgroundColor = UIColor.whiteColor

     @label = UILabel.alloc.initWithFrame(CGRectZero)
     @label.text = "きくぽん"
     @label.sizeToFit
     @label.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 4)
     self.view.addSubview @label

    self.title = "ログイン"
    right_button = UIBarButtonItem.alloc.initWithTitle("Push", style: UIBarButtonItemStyleBordered, target:self, action:'push')
    self.navigationItem.rightBarButtonItem = right_button

    hoge_button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    hoge_button.backgroundColor = UIColor.grayColor
    hoge_button.sizeToFit
    hoge_button.frame = CGRectMake(20, 400, self.view.frame.size.width-40, 50)
    hoge_button.setTitle("Connect with Twitter", forState: UIControlStateNormal)
    hoge_button.tintColor = UIColor.blackColor
    hoge_button.addTarget(self, action:'connectTwitter', forControlEvents:UIControlEventTouchUpInside)
    self.view.addSubview hoge_button

    hoge_button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    hoge_button.backgroundColor = UIColor.grayColor
    hoge_button.sizeToFit
    hoge_button.frame = CGRectMake(20, 340, self.view.frame.size.width-40, 50)
    hoge_button.setTitle("Connect with Facebook", forState: UIControlStateNormal)
    hoge_button.tintColor = UIColor.blackColor
    self.view.addSubview hoge_button
  end

  def push
    new_controller = TapController.alloc.initWithNibName(nil, bundle: nil)
    self.navigationController.pushViewController(new_controller, animated: true)
    #@facebook = SLComposeViewController.composeViewControllerForServiceType(SLServiceTypeFacebook)
    #self.presentViewController(@facebook, animated:TRUE, completion:nil)
  end
  def initWithNibName(name, bundle: bundle)
      super
      self.tabBarItem = UITabBarItem.alloc.initWithTabBarSystemItem(UITabBarSystemItemFavorites, tag: 1)
      self
  end
  def connectTwitter
    @account_store = ACAccountStore.alloc.init
    @account_type = @account_store.accountTypeWithAccountTypeIdentifier(ACAccountTypeIdentifierTwitter);
    @options = {ACFacebookAppIdKey       => '654511364587200',
                ACFacebookPermissionsKey => ['email'],
               }
    @options = nil
    user_id = ""
    user_name = ""
    completion = lambda do |granted, error|
        if granted
            accounts = @account_store.accountsWithAccountType(@account_type)
            anAccount = accounts.lastObject
            user_id = anAccount.valueForKeyPath("properties.user_id")
            NSLog("#{user_id}")
            user_name = anAccount.username
            NSLog("#{user_name}")
            @user = User.new(:twitter_user_id => user_id,
                             :username => user_name
                            )
            alert = UIAlertView.alloc.init
            alert.message = "user_id: #{@user.twitter_user_id}\nuser_name: #{user_name}"
            alert.delegate = self
            alert.addButtonWithTitle "OK"
            alert.show
        else
            NSLog("error: #{error.description}")
        end
    end
    @account_store.requestAccessToAccountsWithType(@account_type, options: @options, completion: completion)
  end
end
