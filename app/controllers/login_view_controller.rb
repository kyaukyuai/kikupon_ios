class LoginViewController < UIViewController
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
    hoge_button.addTarget(self, action:'getTwitterInfo', forControlEvents:UIControlEventTouchUpInside)
    self.view.addSubview hoge_button

    hoge_button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    hoge_button.backgroundColor = UIColor.grayColor
    hoge_button.sizeToFit
    hoge_button.frame = CGRectMake(20, 340, self.view.frame.size.width-40, 50)
    hoge_button.setTitle("Connect with Facebook", forState: UIControlStateNormal)
    hoge_button.tintColor = UIColor.blackColor
    hoge_button.addTarget(self, action:'getFacebookInfo', forControlEvents:UIControlEventTouchUpInside)
    self.view.addSubview hoge_button
    @alert = UIAlertView.new
  end

  def push
    login_view_controller = LoginViewController.new
    self.navigationController.pushViewController(login_view_controller, animated: true)
    #@facebook = SLComposeViewController.composeViewControllerForServiceType(SLServiceTypeFacebook)
    #self.presentViewController(@facebook, animated:TRUE, completion:nil)
  end
  def initWithNibName(name, bundle: bundle)
      super
      self.tabBarItem = UITabBarItem.alloc.initWithTabBarSystemItem(UITabBarSystemItemFavorites, tag: 1)
      self
  end
  # type :twitter or :facebook
  def getSocialInfo(type)
    if type == :twitter
      service_type = SLServiceTypeTwitter
      options = nil
    elsif type == :facebook
      service_type = SLServiceTypeFacebook
      options = {ACFacebookAppIdKey       => '502871253164373',
                 ACFacebookPermissionsKey => ['email'],
                }
    else
      raise "undefined type"
    end
    if !SLComposeViewController.isAvailableForServiceType service_type
      controller = SLComposeViewController.composeViewControllerForServiceType(service_type)
      controller.view.hidden = TRUE
      self.presentViewController(controller, animated:FALSE, completion:nil)
    else
      connectSocial type, options
    end
  end
  def getTwitterInfo
      getSocialInfo :twitter
  end
  def getFacebookInfo
      getSocialInfo :facebook
  end
  def connectSocial(type, options)
    if type == :twitter
      account_type = ACAccountTypeIdentifierTwitter
    elsif type == :facebook
      account_type = ACAccountTypeIdentifierFacebook
    else
      raise "undefined type"
    end
    @account_store = ACAccountStore.new
    @account_type = @account_store.accountTypeWithAccountTypeIdentifier(account_type);
    user_id = ""
    user_name = ""
    completion = lambda do |granted, error|
      if granted
        accounts = @account_store.accountsWithAccountType(@account_type)
        anAccount = accounts.lastObject
        user_id = anAccount.valueForKeyPath("properties.uid")
        NSLog("#{user_id}")
        user_name = anAccount.username
        NSLog("#{user_name}")
        user = ApplicationUser.sharedUser
        user.twitter_user_id = user_id
        user.user_name = user_name
        user.save
        @alert.message = "user_id: #{user.twitter_user_id}\nuser_name: #{user_name}"
        @alert.delegate = self
        @alert.addButtonWithTitle "login success"
        @alert.show
      else
        NSLog("error: #{error.description}")
      end
    end
    @account_store.requestAccessToAccountsWithType(@account_type, options: options, completion: completion)
  end
  def alertView(alertView, clickedButtonAtIndex:buttonIndex)
    item_view_controller = ItemsViewController.new
    self.navigationController.pushViewController(item_view_controller, animated: true)
  end
end
