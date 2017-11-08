import UIKit

class CompanyTableViewCell: UITableViewCell {
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var companyNameLabel: UILabel!
    @IBOutlet weak var workFieldLabel: UILabel!
    @IBOutlet weak var serverLogoImageView: UIImageView!
    @IBOutlet weak var firstIcon: UIImageView!
    @IBOutlet weak var secondIcon: UIImageView!
    @IBOutlet weak var thirdIcon: UIImageView!
    @IBOutlet var imageWidth: NSLayoutConstraint!
    @IBOutlet var imageHeight: NSLayoutConstraint!
    @IBOutlet var arrow: UIImageView!
    
    @IBOutlet var shadow: UIView!
    func setLogo(_ company: Company){
        let image = company.image
            DispatchQueue.main.async(execute: { () -> Void in
                if(image != nil){
                self.logoImageView.backgroundColor = UIColor.white
                if(image!.size.width > image!.size.height){
                    self.imageHeight.constant = 70 * (image!.size.height/image!.size.width )
                    self.imageWidth.constant = 70
                }
                else{
                    self.imageWidth.constant = 70 * (image!.size.width/image!.size.height )
                    self.imageHeight.constant = 70
                        
                    }
                 self.logoImageView.image = image
                }
                else{
                    self.logoImageView.image = nil
                }
            })
    }
}

