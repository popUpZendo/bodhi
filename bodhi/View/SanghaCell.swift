//
//  SanghaCell.swift
//  bodhi
//
//  Created by Joseph Hall on 10/31/17.
//  Copyright © 2017 Joseph Hall. All rights reserved.
//

import UIKit

class SanghaCell: UITableViewCell {

    @IBOutlet weak var profileImage: UIImageView!
    
    
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var groupLbl: UILabel!
    @IBOutlet weak var cityLbl: UILabel!
    @IBOutlet weak var stateLbl: UILabel!
    @IBOutlet weak var templeLbl: UILabel!
    @IBOutlet weak var teacherLbl: UILabel!
    @IBOutlet weak var practiceLbl: UILabel!
    
    func configureSanghaCell(profileImage: UIImage, name: String, popUpGroup: String, city: String, state: String, temple: String, teacher: String, practice: String) {
        self.profileImage.image = profileImage
        self.nameLbl.text = name
        self.groupLbl.text = popUpGroup
        self.cityLbl.text = city
        self.stateLbl.text = state
        self.templeLbl.text = temple
        self.teacherLbl.text = teacher
        self.practiceLbl.text = practice
    }
    
}
