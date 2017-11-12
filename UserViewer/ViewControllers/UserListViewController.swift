//
//  UserListViewController.swift
//  UserViewer
//
//  Created by Sophie on 12.11.17.
//  Copyright © 2017 soet. All rights reserved.
//

import UIKit

class UserListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    var users = [User]()

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        UserFetcher.shared.fetchUsers()
            .then { users -> Void in
                let nonNilUsers = users.flatMap( { $0 } )
                self.users.append(contentsOf: nonNilUsers)
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
            .catch { error in
                print("[ERROR] Error fetching users: \(error)")
        }
    }
}

extension UserListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = users[indexPath.row].name
        return cell
    }
}

extension UserListViewController: UITableViewDelegate {
}
