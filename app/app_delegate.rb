class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    return true if RUBYMOTION_ENV == 'test'

    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)

    loginViewController = UINavigationController.alloc.initWithRootViewController(LoginViewController.new)
    shop_controller = UINavigationController.alloc.initWithRootViewController(ShopController.new)

    tab_controller = UITabBarController.new
    tab_controller.viewControllers = [loginViewController, shop_controller]
    @window.rootViewController = tab_controller
    @window.makeKeyAndVisible
    true
  end
end
