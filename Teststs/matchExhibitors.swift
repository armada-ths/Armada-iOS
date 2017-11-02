//
//  matchExhibitors.swift
//  Armada
//
//  Created by Rebecca Forstén Klinc on 2017-11-01.
//  Copyright © 2017 Rebecca Forstén Klinc. All rights reserved.
//

import UIKit

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
    
    
    var companiesMatch = Array <Company>()
    var matchLEvels = Array <UILabel>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.matchStart?.matchData = matchData!
        if (matchData?.matchResult.isEmpty)!{
            matchData?.currentview -= 1
            matchData?.save()
            // send data back to previous view-controller
            self.matchLoading?.matchData = matchData!
            self.navigationController?.popViewController(animated: false)
        }
        
        print(type(of: matchData?.matchResult[0]["percent"]))
        print(matchData?.matchResult[0])
        id1 = matchData?.matchResult[0]["exhibitor"] as? Int ?? nil
        percent1 = matchData?.matchResult[0]["percent"] as? Double ?? nil
        print(percent1)
        id2 = matchData?.matchResult[1]["exhibitor"] as? Int ?? nil
        percent2 = matchData?.matchResult[1]["percent"] as? Double ?? nil
        id3 = matchData?.matchResult[2]["exhibitor"] as? Int ?? nil
        percent3 = matchData?.matchResult[2]["percent"] as? Double ?? nil
        id4 = matchData?.matchResult[3]["exhibitor"] as? Int ?? nil
        percent4 = matchData?.matchResult[3]["percent"] as? Double ?? nil
        id5 = matchData?.matchResult[4]["exhibitor"] as? Int ?? nil
        percent5 = matchData?.matchResult[4]["percent"] as? Double ?? nil

       let statWindow = UIApplication.shared.value(forKey:"statusBarWindow") as! UIView
        let statusBar = statWindow.subviews[0] as UIView
        statusBar.backgroundColor = UIColor.black
        headerLabel.font = UIFont(name: "BebasNeueRegular", size: 35)
        refreshControl = UIRefreshControl()
        refreshControl?.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl?.addTarget(self, action: "reload:", for: UIControlEvents.valueChanged)
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: true)

    }
    func reload(_ sender:AnyObject){
        let companies = CatalogueFilter.filteredCompanies
        if(id1 != nil){
            company1 = companies.filter{$0.id == id1!}.first
        }
        if(id2 != nil){
            company2 = companies.filter{$0.id == id2!}.first
        }
        if(id3 != nil){
            company3 = companies.filter{$0.id == id3!}.first
        }
        if (id4 != nil){
            company4 = companies.filter{$0.id == id4!}.first
        }
        if(id5 != nil){
        company5 = companies.filter{$0.id == id5!}.first
        }
        //Setup cell 1
        
        if(company1 != nil){
            companiesMatch.append(company1!)
            titleLabel1.text = company1?.name
            setUpLogo(logo1, imageWidth1, imageHeight1, company1!)
            susLogo1.isHidden = true
            divLogo1.isHidden = true
            machLevel1.text = String(describing: percent1!) + "%"
            matchLEvels.append(machLevel1)
            
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
        if(company2 != nil){
            companiesMatch.append(company2!)
            titleLabel2.text = company2?.name
            setUpLogo(logo2, imageWidth2, imageHeight2, company2!)
            susLogo2.isHidden = true
            divLogo2.isHidden = true
            matchLevel2.text = String(describing: percent2!) + "%"
            matchLEvels.append(matchLevel2)


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
        if(company3 != nil){
            companiesMatch.append(company3!)
            titleLabel3.text = company3?.name
            setUpLogo(logo3, imageWidth3, imageHeight3, company3!)
            susLogo3.isHidden = true
            divLogo3.isHidden = true
            matchLevel3.text = String(describing: percent3!) + "%"
            matchLEvels.append(matchLevel3)


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
        if(company4 != nil){
            companiesMatch.append(company4!)
            titleLabel4.text = company4?.name
            setUpLogo(logo4, imageWidth4, imageHeight4, company4!)
            susLogo4.isHidden = true
            divLogo4.isHidden = true
            matchLevel4.text = String(describing: percent4!) + "%"
            matchLEvels.append(matchLevel4)

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
        
        if(company5 != nil){
            companiesMatch.append(company5!)
            titleLabel5.text = company5?.name
            setUpLogo(logo5, imageWidth5, imageHeight5, company5!)
            susLogo5.isHidden = true
            divLogo5.isHidden = true
            matchLevel5.text = String(describing: percent5!) + "%"
            matchLEvels.append(matchLevel5)

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
            let company = companiesMatch[indexPath.row-1]
           controller.company = company
            controller.match = matchLEvels[indexPath.row-1]
            deselectSelectedCell()
        }
    }
    
    func setUpLogo(_ logo: UIImageView, _ width: NSLayoutConstraint, _ height: NSLayoutConstraint, _ company: Company){
        if (company.localImage != nil){
            let image = company.localImage!
            logo1.backgroundColor = UIColor.white
            if(image.size.width > image.size.height){
                height.constant = 70 * (image.size.height/image.size.width )
                width.constant = 70
            }
            else{
                width.constant = 70 * (image.size.width/image.size.height )
                height.constant = 70
                
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