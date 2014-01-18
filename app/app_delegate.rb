class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    return true if RUBYMOTION_ENV == 'test'

    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.makeKeyAndVisible

    @loginViewController = UINavigationController.alloc.initWithRootViewController(LoginViewController.new)
    @itemViewController = UINavigationController.alloc.initWithRootViewController(ItemsViewController.new)

    tab_controller = UITabBarController.new
    tab_controller.viewControllers = [@loginViewController, @itemViewController]
    @window.rootViewController = tab_controller

    true
  end
end
