import UIKit

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

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        UITabBar.appearance().tintColor = ColorScheme.armadaDarkMelon
        window!.tintColor = ColorScheme.armadaDarkMelon
        
        UINavigationBar.appearance().tintColor = ColorScheme.armadaDarkMelon
        
        UITableView.appearance().backgroundColor = UIColor.white
        
        // setup color of back button
        UIProgressView.appearance().tintColor = ColorScheme.armadaDarkMelon

        return true
    }
}

