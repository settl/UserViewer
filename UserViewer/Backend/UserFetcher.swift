//
//  UserFetcher.swift
//  UserViewer
//
//  Created by Sophie on 12.11.17.
//  Copyright © 2017 soet. All rights reserved.
//

import Foundation
import Alamofire
import PromiseKit

class UserFetcher {
    static let shared = UserFetcher()
    
    private init() {}
    var baseURLString = "https://api.github.com/"
    var currentPage = 1
    
    func fetchUsers() -> Promise<[User?]> {
        let urlString = "\(baseURLString)search/users?type=user&q=language:Java&per_page=10&page=\(currentPage)"
        guard let url = URL(string: urlString) else {
            return Promise { _, reject in reject(NSError(domain: "URLFetcher", code: 123, userInfo: nil)) }
        }
        return Promise { fulfill, reject in
            fetchUserList(url: url)
                .then { urls -> Promise<[User?]> in
                    self.incrementPageCount()
                    var promiseForUsers = [Promise<User?>]()
                    for userURL in urls {
                        promiseForUsers.append(self.fetchUser(urlString: userURL))
                    }
                    return when(fulfilled: promiseForUsers)
                }
                .then { users -> Void in
                    fulfill(users)
                }
                .catch { error in
                    print("[ERROR] Error fetching users: \(error)")
                    reject(error)
            }
        }
    }
    
    private func fetchUserList(url: URL) -> Promise<[String]> {
        return Promise { fulfill, reject in
            Alamofire.request(url).validate().responseJSON()
                .then { response -> Void in
                    let urls = UserParser().parseUserList(userList: response)
                    fulfill(urls)
                }
                .catch { error in
                    print("[ERROR] Error fetching user list: \(error)")
                    reject(error)
            }
        }
    }

    private func fetchUser(urlString: String) -> Promise<User?> {
        guard let url = URL(string: urlString) else {
            return Promise { _, reject in reject(NSError(domain: "URLFetcher", code: 123, userInfo: nil)) }
        }
        return Promise { fulfill, reject in
            Alamofire.request(url).validate().responseJSON()
                .then { response -> Void in
                    guard let user = UserParser().parseUser(user: response) else {
                        fulfill(nil)
                        return
                    }
                    fulfill(user)
                }
                .catch { error in
                    print("[ERROR] Error fetching single user: \(error.localizedDescription)")
                    reject(error)
            }
        }
    }
    
    private func incrementPageCount() {
        currentPage += 1
    }
    
    func resetPageCount() {
        currentPage = 1
    }
}
