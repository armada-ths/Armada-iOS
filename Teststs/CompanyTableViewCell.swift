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
    
    func setLogo(_ urlString: String){
        if let logoUrl = URL(string: urlString){
            URLSession.shared.dataTask(with: logoUrl, completionHandler: {(data, response, error) -> Void in
                if error != nil {
                    print(error ?? "error is nil in URLSession.shared.dataTask in NewsArticleViewController.swift")
                    return
                }
                DispatchQueue.main.async(execute: { () -> Void in
                    let image = UIImage(data: data!)!
                    if(image.size.width > image.size.height){
                        self.imageHeight.constant = self.self.imageWidth.constant * (image.size.height/image.size.width )
                    }
                    else{
                        self.imageWidth.constant = self.imageHeight.constant * (image.size.width/image.size.height )
                        
                    }
                    self.logoImageView.image = image
                })
            }).resume()
        }
    }
    
}

