import UIKit
import OneSignal


struct ColorScheme {
    static let leilaDesignGrey = UIColor(hex: 0xF8F7F7)
    static let navbarBorderGrey = UIColor(hex: 0x7F7F7F)
    static let darkGrayTextColor = UIColor(hex: 0x1e1e1e)
    static let armadaBlue = UIColor(hex: 0xe73953)
    static let armadaGreen = UIColor(hex: 0x00d790)
    static let armadaMelon = UIColor(hex: 0x00d790)
    static let armadaDarkMelon = UIColor(hex: 0x00be77)
    static let armadaGrape = UIColor(hex: 0xe73953)
    static let armadaLicorice = UIColor(hex: 0x2d2d2c)
    static let armadaRed = UIColor(hex: 0xE73953)
    static let worldMatchGrey = UIColor(hex: 0x95989A)
    static let diversityRed = UIColor(hex: 0x776aa2)
    static let sustainabilityGreen = UIColor(hex: 0x00D790)
    static let darkGrey = UIColor(hex: 0xe4e4e4)
}
struct emojiStruct {
    static let emojiDict:Array<String> = [
        "😭",
        "☹️",
        "😐",
        "😀",
        "😍"
    ]
}

//0x00d790 Melon
//0xe73953 Grape
//0x2d2d2d Licorice

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        ArmadaApi.updateCompanies {

        }

        for family: String in UIFont.familyNames
        {
            print("\(family)")
            for names: String in UIFont.fontNames(forFamilyName: family)
            {
                print("== \(names)")
            }
        }
        UITabBar.appearance().tintColor = ColorScheme.armadaDarkMelon
        window!.tintColor = ColorScheme.armadaDarkMelon
        
        UINavigationBar.appearance().tintColor = ColorScheme.armadaDarkMelon
        
        UITableView.appearance().backgroundColor = UIColor.white
        
        // setup color of back button
        UIProgressView.appearance().tintColor = ColorScheme.armadaDarkMelon
        
        // setup status-bar style
        UIApplication.shared.statusBarStyle = .lightContent
        
        let defaults = UserDefaults.standard
        if let _ = defaults.value(forKey: "uuid") {
        } else {
            let uuid = UUID().uuidString
            defaults.set(uuid, forKey: "uuid")
            print("created a uuid: \(uuid)")
        }
        /* fetch the matchBackendData if not already done
         this will be done in a non-main thread so don't try
         to access matchDataClass objects "to soon"... */
        ArmadaApi.matchFromServer(1){
            data, error, errormessage in
        }
//        return false
//        if let loaded = matchDataClass().load() {
//            if loaded.grader.count == 0 {
//                
//            }
//        } else {
//            ArmadaApi.matchFromServer(1){
//                data, error, errormessage in
//            }
//            return false
//        }
        
        //UINavigationBar.appearance().barTintColor = ColorScheme.armadaG
        //UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : UIColor(hex: 0x2d2d2d)]
        //        window!.tintColor = ColorScheme.armadaGreen
        //        UINavigationBar.appearance().barTintColor = UIColor.whiteColor()
        //        UINavigationBar.appearance().tintColor = ColorScheme.armadaGreen
        //        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName : ColorScheme.armadaGreen]
        //        UITableView.appearance().backgroundColor = UIColor.whiteColor()
        
        let onesignalInitSettings = [kOSSettingsKeyAutoPrompt: false]
        
        // Replace 'YOUR_APP_ID' with your OneSignal App ID.
        OneSignal.initWithLaunchOptions(launchOptions,
                                        appId: "f2daf00e-b2f0-4da6-a30e-dc90e3791222",
                                        handleNotificationAction: nil,
                                        settings: onesignalInitSettings)
        
        OneSignal.inFocusDisplayType = OSNotificationDisplayType.notification;
        
        // Recommend moving the below line to prompt for push after informing the user about
        //   how your app will use them.
        OneSignal.promptForPushNotifications(userResponse: { accepted in
            print("User accepted notifications: \(accepted)")
        })
        
        // Sync hashed email if you have a login system or collect it.
        //   Will be used to reach the user at the most optimal time of day.
        // OneSignal.syncHashedEmail(userEmail)
        return true
    }

    func loadMatchBackendData() {
        
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

