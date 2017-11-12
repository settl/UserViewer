//
//  UserListCell.swift
//  UserViewer
//
//  Created by Sophie on 12.11.17.
//  Copyright © 2017 soet. All rights reserved.
//

import UIKit
import AlamofireImage

extension UITableViewCell {
    static var identifier: String {
        return String(describing: self)
    }
}

class UserListCell: UITableViewCell {
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var registrationDateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        registrationDateLabel.textColor = .lightGray
        avatarImageView.contentMode = .scaleAspectFill
        avatarImageView.clipsToBounds = true
    }
    
    override func layoutSubviews() {
        avatarImageView.layer.cornerRadius = avatarImageView.frame.size.width / 2
        super.layoutSubviews()
    }
    
    func configure(user: User) {
        nameLabel.text = user.name
        if let formattedDateString = UserViewModel.formatRegistrationDate(date: user.registrationDate) {
            registrationDateLabel.text = formattedDateString
        }
        guard let imageURL = URL(string: user.avatarURL) else {
            return
        }
        avatarImageView.af_setImage(withURL: imageURL,
                                    placeholderImage: nil,
                                    imageTransition: .crossDissolve(0.2))
    }
    
    override func prepareForReuse() {
        imageView?.image = nil
    }
}
