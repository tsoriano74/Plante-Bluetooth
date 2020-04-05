//
//  ScanBluetoothCell.swift
//  Plante Bluetooth
//
//  Created by Naomi Baudoin on 03.04.20.
//  Copyright © 2020 LVN. All rights reserved.
//

import UIKit

protocol cellDelegate {
    func cellSelected(cell: ScanBluetoothCell)
}

class ScanBluetoothCell: UITableViewCell {
    

    @IBOutlet var labelCell: UILabel!
    @IBOutlet var rssiState: UIImageView!
    @IBOutlet var rssiNumber: UILabel!
    
    var delegate: cellDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        delegate?.cellSelected(cell: self)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            
        } else {
           
        }
        // Configure the view for the selected state
    }

}
