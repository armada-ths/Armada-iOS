import UIKit

struct ColorScheme {
    static let darkGrayTextColor = UIColor(hex: 0x1e1e1e)
    static let armadaBlue = UIColor(hex: 0x273760)
    static let armadaGreen = UIColor(hex: 0x1C6965)
}


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        UITabBar.appearance().tintColor = ColorScheme.armadaGreen
        window!.tintColor = ColorScheme.armadaGreen
        UINavigationBar.appearance().barTintColor = ColorScheme.armadaGreen
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
        UITableView.appearance().backgroundColor = UIColor.whiteColor()
        
//        window!.tintColor = ColorScheme.armadaGreen
//        UINavigationBar.appearance().barTintColor = UIColor.whiteColor()
//        UINavigationBar.appearance().tintColor = ColorScheme.armadaGreen
//        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : ColorScheme.armadaGreen]
//        UITableView.appearance().backgroundColor = UIColor.whiteColor()
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

