import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        selectedIndex = 1
        
        // setup footer top border
        let topBorderRect = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 0.5)
        let topBorderView = UIView(frame: topBorderRect)
        topBorderView.backgroundColor = ColorScheme.navbarBorderGrey
        self.tabBar.addSubview(topBorderView)
        
    }
    
    
}
