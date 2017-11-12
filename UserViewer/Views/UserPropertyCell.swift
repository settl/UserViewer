//
//  UserPropertyCell.swift
//  UserViewer
//
//  Created by Sophie on 12.11.17.
//  Copyright © 2017 soet. All rights reserved.
//

import UIKit

class UserPropertyCell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(item: UserViewModelItem) {
        guard let viewModelItem = item as? UserViewModelPropertyItem else {
            return
        }
        textLabel?.text = viewModelItem.text
        imageView?.image = viewModelItem.icon
    }
}
