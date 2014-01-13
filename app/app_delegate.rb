class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)

    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.makeKeyAndVisible

    # This is our new line!
    #@window.rootViewController = TapController.alloc.initWithNibName(nil, bundle: nil)
    controller = TapController.alloc.initWithNibName(nil, bundle: nil)
    nav_controller = UINavigationController.alloc.initWithRootViewController(controller)
    alphabet_controller = AlphabetController.alloc.initWithNibName(nil, bundle: nil)

    item_nav_controller = UINavigationController.alloc.initWithRootViewController(ItemsViewController.new)

    tab_controller = UITabBarController.alloc.initWithNibName(nil, bundle: nil)
    tab_controller.viewControllers = [nav_controller, alphabet_controller, item_nav_controller]
    @window.rootViewController = tab_controller

    true
  end
end
