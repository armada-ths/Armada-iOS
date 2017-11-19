//
//  matchExhibitors.swift
//  Armada
//
//  Created by Rebecca Forstén Klinc on 2017-11-01.
//  Copyright © 2017 Rebecca Forstén Klinc. All rights reserved.
//




import UIKit
import Airbrake_iOS

class matchExhibitors: UITableViewController {
    
    
    var matchData: matchDataClass?
    var matchStart: matchStart?
    var matchLoading: matchLoading?
    let viewNumber = 10
    
    //HeaderCell
    @IBOutlet var headerCell: UITableViewCell!
    @IBOutlet var headerLabel: UILabel!
    
    //Cell 1
    @IBOutlet var cell1: UITableViewCell!
    @IBOutlet var logo1: UIImageView!
    @IBOutlet var machLevel1: UILabel!
    @IBOutlet var arrow1: UIImageView!
    @IBOutlet var titleLabel1: UILabel!
    @IBOutlet var divLogo1: UIImageView!
    @IBOutlet var susLogo1: UIImageView!
    var company1: Company?
    var percent1: Double?
    var id1: Int?
    @IBOutlet var imageHeight1: NSLayoutConstraint!
    @IBOutlet var imageWidth1: NSLayoutConstraint!
    var reasons1: [String]?
    
    //Cell 2
    @IBOutlet var cell2: UITableViewCell!
    @IBOutlet var titleLabel2: UILabel!
    @IBOutlet var logo2: UIImageView!
    @IBOutlet var divLogo2: UIImageView!
    @IBOutlet var susLogo2: UIImageView!
    @IBOutlet var matchLevel2: UILabel!
    @IBOutlet var arrow2: UIImageView!
    var id2: Int?
    var company2: Company?
    var percent2: Double?
    @IBOutlet var imageHeight2: NSLayoutConstraint!
    @IBOutlet var imageWidth2: NSLayoutConstraint!
    var reasons2: [String]?
    
    //Cell 3
    @IBOutlet var cell3: UITableViewCell!
    @IBOutlet var matchLevel3: UILabel!
    @IBOutlet var arrow3: UIImageView!
    @IBOutlet var titleLabel3: UILabel!
    @IBOutlet var divLogo3: UIImageView!
    @IBOutlet var susLogo3: UIImageView!
    @IBOutlet var logo3: UIImageView!
    var company3: Company?
    var percent3: Double?
    var id3: Int?
    var reasons3: [String]?
    
    @IBOutlet var imageHeight3: NSLayoutConstraint!
    @IBOutlet var imageWidth3: NSLayoutConstraint!
    
    
    //Cell 4
    @IBOutlet var cell4: UITableViewCell!
    @IBOutlet var matchLevel4: UILabel!
    @IBOutlet var arrow4: UIImageView!
    @IBOutlet var titleLabel4: UILabel!
    @IBOutlet var divLogo4: UIImageView!
    @IBOutlet var susLogo4: UIImageView!
    @IBOutlet var logo4: UIImageView!
    var company4: Company?
    var percent4: Double?
    var id4: Int?
    @IBOutlet var imageWidth4: NSLayoutConstraint!
    @IBOutlet var imageHeight4: NSLayoutConstraint!
    var reasons4: [String]?
    
    
    //Cell 5
    @IBOutlet var cell5: UITableViewCell!
    @IBOutlet var matchLevel5: UILabel!
    @IBOutlet var arrow5: UIImageView!
    @IBOutlet var titleLabel5: UILabel!
    @IBOutlet var divLogo5: UIImageView!
    @IBOutlet var susLogo5: UIImageView!
    @IBOutlet var logo5: UIImageView!
    var company5: Company?
    var percent5: Double?
    var id5: Int?
    @IBOutlet var imageWidth5: NSLayoutConstraint!
    @IBOutlet var imageHeight5: NSLayoutConstraint!
    var reasons5: [String]?
    
    //Cell Linkedin
    
    @IBOutlet weak var liLabel: UILabel!
    @IBOutlet weak var liButton: UIButton!
    @IBAction func liButtonPush(_ sender: Any) {
        pushLIbutton()
    }
    
    var companiesMatch = Array <Company>()
    var matchLEvels = Array <UILabel>()
    var companiesScore = [[String: AnyObject]]()
    var reasons = [[String]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        headerLabel.layer.zPosition = 1
        cell1.layer.zPosition = 5
        cell2.layer.zPosition = 4
        cell3.layer.zPosition = 3
        cell4.layer.zPosition = 2
        cell5.layer.zPosition = 1
        let liText = NSMutableAttributedString(
            string: "We really want to know who you are. Sign in with your LinkedIn® and share your profile with exhibitors at the fair.",
            attributes: [NSFontAttributeName:UIFont(
                name: "Lato",
                size: 17)!, NSForegroundColorAttributeName: UIColor.black])
        liLabel.attributedText = liText
        
        self.matchStart?.matchData = matchData!
        if (matchData?.matchResult.isEmpty)!{
            matchData?.currentview -= 1
            matchData?.save()
            // send data back to previous view-controller
            self.matchLoading?.matchData = matchData!
            self.navigationController?.popViewController(animated: false)
        }
        
        id1 = matchData?.matchResult[0]["exhibitor"] as? Int ?? nil
        reasons1 = matchData?.matchResult[0]["reasons"] as? [String] ?? nil
        percent1 = matchData?.matchResult[0]["percent"] as? Double ?? nil
        
        id2 = matchData?.matchResult[1]["exhibitor"] as? Int ?? nil
        percent2 = matchData?.matchResult[1]["percent"] as? Double ?? nil
        reasons2 = matchData?.matchResult[1]["reasons"] as? [String] ?? nil
        
        id3 = matchData?.matchResult[2]["exhibitor"] as? Int ?? nil
        percent3 = matchData?.matchResult[2]["percent"] as? Double ?? nil
        reasons3 = matchData?.matchResult[2]["reasons"] as? [String] ?? nil
        
        id4 = matchData?.matchResult[3]["exhibitor"] as? Int ?? nil
        percent4 = matchData?.matchResult[3]["percent"] as? Double ?? nil
        reasons4 = matchData?.matchResult[3]["reasons"] as? [String] ?? nil
        
        id5 = matchData?.matchResult[4]["exhibitor"] as? Int ?? nil
        percent5 = matchData?.matchResult[4]["percent"] as? Double ?? nil
        reasons5 = matchData?.matchResult[4]["reasons"] as? [String] ?? nil
        
        
        
        let statWindow = UIApplication.shared.value(forKey:"statusBarWindow") as! UIView
        let statusBar = statWindow.subviews[0] as UIView
        statusBar.backgroundColor = UIColor.black
        headerLabel.font = UIFont(name: "BebasNeueRegular", size: 35)
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl?.addTarget(self, action: #selector(matchExhibitors.reload(_:)), for: UIControlEvents.valueChanged)
        // tableView.addSubview(refreshControl!) // not required when using UITableViewController
        
        //Load companies
        ArmadaApi.updateCompanies {
            OperationQueue.main.addOperation {
                self.reload("Nothing" as AnyObject)
            }
        }
        
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func reload(_ sender:AnyObject){
        let companies = CatalogueFilter.filteredCompanies
        if(id1 != nil){
            if let company1 = (companies.filter{$0.id == id1!}.first) as? Company{
                companiesScore.append(["score": percent1 as AnyObject, "company": company1])
                reasons.append(reasons1!)
                self.company1 = company1
            }
            else{
                self.company1 = nil
            }
        }
        if(id2 != nil){
            if let company2 = (companies.filter{$0.id == id2!}.first) as? Company{
                companiesScore.append(["score": percent2 as AnyObject, "company": company2])
                self.company2 = company2
                reasons.append(reasons2!)
                
            }
            else{
                self.company2 = nil
            }        }
        if(id3 != nil){
            if let company3 = (companies.filter{$0.id == id3!}.first) as? Company{
                companiesScore.append(["score": percent3 as AnyObject, "company": company3])
                self.company3 = company3
                reasons.append(reasons3!)
                
            }
            else{
                self.company3 = nil
            }        }
        if (id4 != nil){
            if let company4 = (companies.filter{$0.id == id4!}.first) as? Company{
                companiesScore.append(["score": percent4 as AnyObject, "company": company4])
                self.company4 = company4
                reasons.append(reasons4!)
                
            }
            else{
                self.company4 = nil
            }        }
        if(id5 != nil){
            if let company5 = (companies.filter{$0.id == id5!}.first) as? Company{
                companiesScore.append(["score": percent5 as AnyObject, "company": company5])
                self.company5 = company5
                reasons.append(reasons5!)
                
            }
            else{
                self.company5 = nil
            }
            
        }
        //Setup cell 1
        var index = 0
        if(index < companiesScore.count){
            //companiesMatch.append(company1!)
            company1 = companiesScore[index]["company"] as! Company
            titleLabel1.text = company1?.name
            setUpLogo(logo1, imageWidth1, imageHeight1, company1!)
            susLogo1.isHidden = true
            divLogo1.isHidden = true
            machLevel1.text = String(describing: companiesScore[index]["score"]!) + "%"
            matchLEvels.append(machLevel1)
            index += 1
            
            if(company1!.likesEquality){
                arrow1.image = #imageLiteral(resourceName: "wArrow")
                divLogo1.isHidden = false
                cell1.backgroundColor = ColorScheme.diversityRed
            }
            else if (company1!.likesEnvironment){
                arrow1.image = #imageLiteral(resourceName: "wArrow")
                susLogo1.isHidden = false
                cell1.backgroundColor = ColorScheme.sustainabilityGreen
            }
        }
        else{
            cell1.isHidden = true
        }
        
        
        //Setup Cell2
        if(index < companiesScore.count){
            //companiesMatch.append(company1!)
            company2 = companiesScore[index]["company"] as! Company
            titleLabel2.text = company2?.name
            setUpLogo(logo2, imageWidth2, imageHeight2, company2!)
            susLogo2.isHidden = true
            divLogo2.isHidden = true
            matchLevel2.text = String(describing: companiesScore[index]["score"]!) + "%"
            matchLEvels.append(matchLevel2)
            index += 1
            
            
            if(company2!.likesEquality){
                arrow2.image = #imageLiteral(resourceName: "wArrow")
                divLogo2.isHidden = false
                cell2.backgroundColor = ColorScheme.diversityRed
            }
            else if (company2!.likesEnvironment){
                arrow2.image = #imageLiteral(resourceName: "wArrow")
                susLogo2.isHidden = false
                cell2.backgroundColor = ColorScheme.sustainabilityGreen
            }
        }
        else{
            cell2.isHidden = true
        }
        
        //Setup Cell3
        if(index < companiesScore.count){
            //companiesMatch.append(company1!)
            company3 = companiesScore[index]["company"] as! Company
            titleLabel3.text = company3?.name
            setUpLogo(logo3, imageWidth3, imageHeight3, company3!)
            susLogo3.isHidden = true
            divLogo3.isHidden = true
            matchLevel3.text = String(describing: companiesScore[index]["score"]!) + "%"
            matchLEvels.append(matchLevel3)
            index += 1
            
            if(company3!.likesEquality){
                arrow3.image = #imageLiteral(resourceName: "wArrow")
                divLogo3.isHidden = false
                cell3.backgroundColor = ColorScheme.diversityRed
            }
            else if (company3!.likesEnvironment){
                arrow3.image = #imageLiteral(resourceName: "wArrow")
                susLogo3.isHidden = false
                cell3.backgroundColor = ColorScheme.sustainabilityGreen
            }
        }
        else{
            cell3.isHidden = true
        }
        
        
        //Setup Cell4
        if(index < companiesScore.count){
            //            companiesMatch.append(company4!)
            company4 = companiesScore[index]["company"] as! Company
            titleLabel4.text = company4?.name
            setUpLogo(logo4, imageWidth4, imageHeight4, company4!)
            susLogo4.isHidden = true
            divLogo4.isHidden = true
            matchLevel4.text = String(describing: companiesScore[index]["score"]!) + "%"
            matchLEvels.append(matchLevel4)
            index += 1
            
            if(company4!.likesEquality){
                arrow4.image = #imageLiteral(resourceName: "wArrow")
                divLogo4.isHidden = false
                cell4.backgroundColor = ColorScheme.diversityRed
            }
            else if (company4!.likesEnvironment){
                arrow4.image = #imageLiteral(resourceName: "wArrow")
                susLogo4.isHidden = false
                cell4.backgroundColor = ColorScheme.sustainabilityGreen
            }
        }
        else{
            cell4.isHidden = true
            
        }
        
        //Setup Cell5
        
        if(index < companiesScore.count){
            //companiesMatch.append(company1!)
            company5 = companiesScore[index]["company"] as! Company
            titleLabel5.text = company5?.name
            setUpLogo(logo5, imageWidth5, imageHeight5, company5!)
            susLogo5.isHidden = true
            divLogo5.isHidden = true
            matchLevel5.text = String(describing: companiesScore[index]["score"]!) + "%"
            matchLEvels.append(matchLevel5)
            // index +=1
            
            if(company5!.likesEquality){
                arrow5.image = #imageLiteral(resourceName: "wArrow")
                divLogo5.isHidden = false
                cell5.backgroundColor = ColorScheme.diversityRed
            }
            else if (company2!.likesEnvironment){
                arrow5.image = #imageLiteral(resourceName: "wArrow")
                susLogo5.isHidden = false
                cell5.backgroundColor = ColorScheme.sustainabilityGreen
            }
        }
        else{
            cell5.isHidden = true
        }
        if (refreshControl?.isRefreshing)!{
            refreshControl?.endRefreshing()
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if let controller = segue.destination as? matchDetailExhibitor,
            let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
            let company = companiesScore[indexPath.row-1]["company"] as! Company
            controller.company = company
            controller.match = matchLEvels[indexPath.row-1]
            controller.reasons = reasons[indexPath.row-1]
            deselectSelectedCell()
        }
    }
    
    func setUpLogo(_ logo: UIImageView, _ width: NSLayoutConstraint, _ height: NSLayoutConstraint, _ company: Company){
        if (company.localImage != nil){
            let image = company.localImage!
            logo1.backgroundColor = UIColor.white
            if(image.size.width > image.size.height){
                height.constant = 50 * (image.size.height/image.size.width )
                width.constant = 50
            }
            else{
                width.constant = 50 * (image.size.width/image.size.height )
                height.constant = 50
                
            }
            logo.image = image
        }
        else{
            let image = company.image
            DispatchQueue.main.async(execute: { () -> Void in
                if(image != nil){
                    logo.backgroundColor = UIColor.white
                    if(image!.size.width > image!.size.height){
                        height.constant = 70 * (image!.size.height/image!.size.width )
                        width.constant = 70
                    }
                    else{
                        width.constant = 70 * (image!.size.width/image!.size.height )
                        height.constant = 70
                        
                    }
                    logo.image = image
                }
                else{
                    logo.image = nil
                }
            })
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 7
    }
    @IBAction func redoMatch(_ sender: Any) {
        matchData?.currentview = 0
        matchData?.save()
        matchStart?.matchData = matchData!
        var viewControllers = navigationController?.viewControllers
        viewControllers?.removeLast(10) // views to pop
        navigationController?.setViewControllers(viewControllers!, animated: true)
    }
    
    // LINKEDIN STUFF
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        
        // check for liprofile
        if let _ = UserDefaults.standard.object(forKey: "LIprofile"){
            let liText = NSMutableAttributedString(
                string: "You are logged in with LinkedIn®",
                attributes: [NSFontAttributeName:UIFont(
                    name: "Lato-Bold",
                    size: 17)!, NSForegroundColorAttributeName: UIColor.black])
            liLabel.attributedText = liText
            liButton.isHidden = true
        } else if let webAccessToken = UserDefaults.standard.object(forKey: "webAccessToken") {
            print("running webGetProfile")
            self.webGetProfile(accessToken: webAccessToken as! String)
        }
    }
    
    func pushLIbutton(){
        var haveLIinfo: Bool = false
        if let profileString = UserDefaults.standard.value(forKey: "LIprofile") {
            haveLIinfo = true
            print("profileString is \(profileString)")
        }
        if haveLIinfo {
            print("you already logged in :)")
            print(UserDefaults.standard.value(forKey: "LIprofile"))
        } else {
            let haveApp = LinkedinAppExists()
            print("haveApp")
            print("\(haveApp)")
            if haveApp {
                // TRY TO GET APP TOKEN
                print("try to get app token")
                getAppToken()
            } else {
                // TRY TO GET WEB TOKEN
                getWebToken()
            }
            
        }
    }
    
    func LinkedinAppExists() -> Bool {
        let appName = "LinkedIn"
        let appScheme = "\(appName)://app"
        let appUrl = URL(string: appScheme)
        if UIApplication.shared.canOpenURL(appUrl! as URL)
        {
            return true
            
        } else {
            return false
        }
    }
    
    func getAppToken() -> String {
        print("inside getapptoken")
        LISDKSessionManager.createSession(withAuth: [LISDK_BASIC_PROFILE_PERMISSION], state: nil, showGoToAppStoreDialog: true, successBlock: {(returnState) -> Void in
            print("success called!")
            if LISDKSessionManager.hasValidSession() {
                let accessToken = LISDKSessionManager.sharedInstance().session.accessToken.accessTokenValue
                UserDefaults.standard.set(accessToken, forKey: "appAccessToken")
                print("appAccessToken \(accessToken)")
                self.appGetProfile(accessToken: accessToken as! String)
                
            }
        }, errorBlock: {(error) -> Void in
            print("Error: \(error)")
        })
        return ""
    }
    
    func appGetProfile(accessToken: String) {
        // Specify the URL string that we'll get the profile info from.
        let targetURLString = "https://api.linkedin.com/v1/people/~:(public-profile-url)?format=json"
        
        // Initialize a mutable URL request object.
        let request = NSMutableURLRequest(url: NSURL(string: targetURLString)! as URL)
        
        // Indicate that this is a GET request.
        request.httpMethod = "GET"
        
        // Add the access token as an HTTP header field.
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.addValue("it-IT", forHTTPHeaderField: "Accept-Language")
        request.addValue("msdk", forHTTPHeaderField: "x-li-src")
        // Initialize a NSURLSession object.
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        // Make the request.
        let task: URLSessionDataTask = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            if let error = error as NSError? {
                ABNotifier.logException(NSException(name: NSExceptionName(rawValue: "Function: appGetProfile(accessToken: String)"), reason: error.localizedDescription, userInfo: [:]))
                print(error.localizedDescription)
                return
            }
            // Get the HTTP status code of the request.
            let statusCode = (response as! HTTPURLResponse).statusCode
            print(statusCode)
            if statusCode == 200 {
                // Convert the received JSON data into a dictionary.
                do {
                    let dataDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String: AnyObject]
                    print(dataDictionary)
                    let profileURLString = dataDictionary["publicProfileUrl"] as! String
                    
                    DispatchQueue.main.async(execute: { () -> Void in
                        UserDefaults.standard.set(profileURLString, forKey: "LIprofile")
                        self.sendLItoServer(LIprofile: profileURLString)
                        let liText = NSMutableAttributedString(
                            string: "You are logged in with LinkedIn®",
                            attributes: [NSFontAttributeName:UIFont(
                                name: "Lato-Bold",
                                size: 17)!, NSForegroundColorAttributeName: UIColor.black])
                        self.liLabel.attributedText = liText
                        self.liButton.isHidden = true
                    })
                }
                catch {
                    print("Could not convert JSON data into a dictionary.")
                }
            }
        }
        task.resume()
    }
    
    func sendLItoServer(LIprofile: String) {
        let putURLString = "http://gotham.armada.nu/api/student_profile?student_id="
        let student_id = UserDefaults.standard.value(forKey: "uuid") as! String
        let dict = ["linkedin_profile": LIprofile, "nickname": student_id]
        let url = URL(string: putURLString + student_id)
        var request = URLRequest(url: url!)
        request.httpMethod = "put"
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted) // pass dictionary to nsdata
        } catch let error {
            print(error.localizedDescription)
        }
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                if let error = error as NSError? {
                    ABNotifier.logException(NSException(name: NSExceptionName(rawValue: "Function: sendLItoServer(LIprofile: String)"), reason: error.localizedDescription, userInfo: [:]))
                    print(error.localizedDescription ?? "No data")
                    return
                }
                return
            }
        }
        task.resume()
    }
    
    func getWebToken() {
        let webview = self.storyboard?.instantiateViewController(withIdentifier: "liwebview") as! LinkedinWebViewController
        self.present(webview, animated: true, completion: nil)
    }
    
    func webGetProfile(accessToken: String) {
        // Specify the URL string that we'll get the profile info from.
        let targetURLString = "https://api.linkedin.com/v1/people/~:(public-profile-url)?format=json"
        
        // Initialize a mutable URL request object.
        let request = NSMutableURLRequest(url: NSURL(string: targetURLString)! as URL)
        
        // Indicate that this is a GET request.
        request.httpMethod = "GET"
        
        // Add the access token as an HTTP header field.
        request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        request.addValue("it-IT", forHTTPHeaderField: "Accept-Language")
        // Initialize a NSURLSession object.
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        // Make the request.
        let task: URLSessionDataTask = session.dataTask(with: request as URLRequest) { (data, response, error) -> Void in
            if let error = error as NSError? {
                ABNotifier.logException(NSException(name: NSExceptionName(rawValue: "Function: webGetProfile(accessToken: String)"), reason: error.localizedDescription, userInfo: [:]))
                print(error.localizedDescription ?? "No data")
                return
            }
            // Get the HTTP status code of the request.
            let statusCode = (response as! HTTPURLResponse).statusCode
            
            if statusCode == 200 {
                // Convert the received JSON data into a dictionary.
                do {
                    let dataDictionary = try JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.mutableContainers) as! [String: AnyObject]
                    print(dataDictionary)
                    let profileURLString = dataDictionary["publicProfileUrl"] as! String
                    DispatchQueue.main.async(execute: { () -> Void in
                        UserDefaults.standard.set(profileURLString, forKey: "LIprofile")
                        self.sendLItoServer(LIprofile: profileURLString)
                        let liText = NSMutableAttributedString(
                            string: "You are logged in with LinkedIn®",
                            attributes: [NSFontAttributeName:UIFont(
                                name: "Lato-Bold",
                                size: 17)!, NSForegroundColorAttributeName: UIColor.black])
                        self.liLabel.attributedText = liText
                        self.liButton.isHidden = true
                    })
                }
                catch {
                    print("Could not convert JSON data into a dictionary.")
                }
            }
        }
        task.resume()
    }
    
    
    override func tableView(_ tableView: UITableView,
                            canEditRowAt indexPath: IndexPath) -> Bool{
        return false
    }
    /*
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
     
     // Configure the cell...
     
     return cell
     }
     */
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

