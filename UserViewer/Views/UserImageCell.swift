//
//  UserImageCell.swift
//  PeopleViewer
//
//  Created by Sophie on 12.11.17.
//  Copyright © 2017 soet. All rights reserved.
//

import UIKit

class UserImageCell: UITableViewCell {
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
        
        avatarImageView.clipsToBounds = true
        avatarImageView.layer.borderWidth = 3.0
        avatarImageView.layer.borderColor = UIColor.lightGray.cgColor
    }

    override func layoutSubviews() {
        avatarImageView.layer.cornerRadius = avatarImageView.frame.size.width / 2
        super.layoutSubviews()
    }
    
    func configure(item: UserViewModelItem) {
        guard let viewModelItem = item as? UserViewModelNameImageItem else {
            return
        }
        nameLabel.text = viewModelItem.name
        guard let url = URL(string: viewModelItem.avatarURL) else {
            return
        }
        avatarImageView.af_setImage(withURL: url, placeholderImage: nil)
    }
    
}
