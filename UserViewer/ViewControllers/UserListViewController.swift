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
    let cellHeight: CGFloat = 60
    var activityIndicator = UIActivityIndicatorView()

    var users = [User]()
    var fetching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Java Users"
        tableView.register(UserListCell.self, forCellReuseIdentifier: UserListCell.identifier)
        tableView.tableFooterView = UIView(frame: .zero)
        showActivityIndicator()
        fetchMoreUsers()
    }

    func showActivityIndicator() {
        activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 120, height: 120))
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        tableView.addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            activityIndicator.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: tableView.centerYAnchor, constant: -80)
            ])
        
        activityIndicator.startAnimating()
    }
    
    func fetchMoreUsers() {
        guard fetching == false else {
            return
        }
        fetching = true
        UserFetcher.shared.fetchUsers()
            .then { users -> Void in
                self.fetching = false
                self.activityIndicator.stopAnimating()
                self.activityIndicator.hidesWhenStopped = true
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
        let cell = tableView.dequeueReusableCell(withIdentifier: UserListCell.identifier, for: indexPath) as! UserListCell
        cell.configure(user: users[indexPath.row])
        
        if indexPath.row == users.count - 1 { // last cell
            fetchMoreUsers()
        }
        return cell
    }
}

extension UserListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
}
