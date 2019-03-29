//
//  ThemeCell.swift
//  Line Charts
//
//  Created by Dmytro Dobrovolskyy on 3/18/19.
//  Copyright © 2019 LackyUA. All rights reserved.
//

import UIKit

class ThemeCell: UITableViewCell {
    
    func configure(text: String) {
        textLabel?.text = text
        textLabel?.textAlignment = .center
    }
    
}
