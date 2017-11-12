//
//  UserViewModel.swift
//  UserViewer
//
//  Created by Sophie on 12.11.17.
//  Copyright © 2017 soet. All rights reserved.
//

import Foundation
import UIKit

enum UserViewModelItemType {
    case nameAndImage
    case email
    case property
}

protocol UserViewModelItem {
    var type: UserViewModelItemType { get }
}

struct UserViewModel {
    var items = [UserViewModelItem]()
    
    init(user: User) {
        items.append(UserViewModelNameImageItem(name: user.name, avatarURL: user.avatarURL))
        items.append(UserViewModelPropertyItem(type: .email, text: user.email, icon: #imageLiteral(resourceName: "icon")))
        items.append(UserViewModelPropertyItem(type: .property, text: user.registrationDate, icon: #imageLiteral(resourceName: "icon")))
    }
}

struct UserViewModelNameImageItem: UserViewModelItem {
    let type: UserViewModelItemType = .nameAndImage
    var name: String
    var avatarURL: String
    
    init(name: String, avatarURL: String) {
        self.name = name
        self.avatarURL = avatarURL
    }
}

struct UserViewModelPropertyItem: UserViewModelItem {
    var type: UserViewModelItemType
    var text: String
    var icon: UIImage
}
