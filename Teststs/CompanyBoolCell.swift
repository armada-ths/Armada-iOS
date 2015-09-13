import UIKit

protocol CompanyBoolCellDelegate {
 
    func armadaFieldType(armadaFieldType: _DataDude.ArmadaFieldType, isOn: Bool)
}


class CompanyBoolCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueSwitch: UISwitch!
    @IBOutlet weak var numberOfJobsLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    
    
    var armadaFieldType: _DataDude.ArmadaFieldType!
    var delegate: CompanyBoolCellDelegate?
    
    @IBAction func switchChanged(sender: UISwitch) {
        delegate?.armadaFieldType(armadaFieldType, isOn: sender.on)
    }

    
}
