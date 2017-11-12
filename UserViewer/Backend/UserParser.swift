//
//  UserParser.swift
//  UserViewer
//
//  Created by Sophie on 12.11.17.
//  Copyright © 2017 soet. All rights reserved.
//

import Foundation

struct UserParser {
    func parseUserList(userList: Any) -> [String] {
        guard let jsonDict = userList as? [String: Any] else {
            return []
        }
        guard let items = jsonDict["items"] as? [[String: Any]] else {
            return []
        }
        var urls = [String]()
        for item in items {
            if let url = item["url"] as? String {
                urls.append(url)
            }
        }
        return urls
    }
    
    func parseUser(user: Any) -> User? {
        guard let jsonDict = user as? [String: Any] else {
            return nil
        }
        guard
            let name = jsonDict["name"] as? String,
            let registrationDate = jsonDict["created_at"] as? String,
            let avatarURL = jsonDict["avatar_url"] as? String,
            let email = jsonDict["email"] as? String else {
                print("parsing error")
                return nil
        }
        return User(name: name,
                    email: email,
                    avatarURL: avatarURL,
                    registrationDate: registrationDate)
    }
}
