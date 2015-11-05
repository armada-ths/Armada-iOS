import UIKit

protocol CompanyBoolCellDelegate {
 
    func armadaField(armadaField: ArmadaField, isOn: Bool)
}


class CompanyBoolCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueSwitch: UISwitch!
    @IBOutlet weak var numberOfJobsLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    
    
    var armadaField: ArmadaField!
    var delegate: CompanyBoolCellDelegate?
    
    @IBAction func switchChanged(sender: UISwitch) {
        delegate?.armadaField(armadaField, isOn: sender.on)
    }

    
}
