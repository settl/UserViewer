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
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        self.detailTextLabel?.textColor = .gray
        self.imageView?.contentMode = .scaleAspectFill
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    func configure(user: User) {
        textLabel?.text = user.name
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let date = ISO8601DateFormatter().date(from: user.registrationDate)
        let s = dateFormatter.string(from: date!)
        
        detailTextLabel?.text = "member since: \(s)"
        guard let imageURL = URL(string: user.avatarURL) else {
            return
        }
        imageView?.af_setImage(withURL: imageURL,
                               placeholderImage: #imageLiteral(resourceName: "placeholder"),
                               imageTransition: .crossDissolve(0.2))
    }
    
    override func prepareForReuse() {
        imageView?.image = nil
    }
}

