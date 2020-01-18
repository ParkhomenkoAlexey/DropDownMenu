//
//  DropDownCell.swift
//  DropDownMenu
//
//  Created by Алексей Пархоменко on 18.01.2020.
//  Copyright © 2020 Алексей Пархоменко. All rights reserved.
//

import Foundation
import UIKit

class DropDownCell: UITableViewCell {
    
    static let reuseId = "DropDownCell"
    
    let titleLabel: UILabel = {
       let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
        
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(titleLabel)
        titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
