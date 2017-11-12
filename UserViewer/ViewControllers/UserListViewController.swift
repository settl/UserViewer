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
    fileprivate let cellHeight: CGFloat = 80
    fileprivate var activityIndicator = UIActivityIndicatorView()
    fileprivate let refreshControl = UIRefreshControl()

    fileprivate var users = [User]()
    fileprivate var isFetching = false
    fileprivate var isRefreshing = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Java Users"
        tableView.register(UINib(nibName: "UserListCell", bundle: nil), forCellReuseIdentifier: UserListCell.identifier)
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
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
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
    }
    
    @objc func refresh() {
        guard !isFetching else {
            return
        }
        isRefreshing = true
        tableView.refreshControl?.beginRefreshing()
        fetchMoreUsers()
    }
    
    func fetchMoreUsers() {
        guard !isFetching else {
            return
        }
        isFetching = true
        UserFetcher.shared.fetchUsers()
            .then { users -> Void in
                let nonNilUsers = users.flatMap( { $0 } )
                if self.isRefreshing {
                    self.users = nonNilUsers
                } else {
                    self.users.append(contentsOf: nonNilUsers)
                }
                DispatchQueue.main.async {
                    self.stopFetching()
                    self.tableView.reloadData()
                }
            }
            .catch { error in
                print("[ERROR] Error fetching users: \(error)")
                self.stopFetching()
        }
    }
    
    func stopFetching() {
        self.activityIndicator.stopAnimating()
        tableView.refreshControl?.endRefreshing()
        self.isFetching = false
        self.isRefreshing = false
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let userDetailViewController = UserDetailViewController(user: users[indexPath.row])
        navigationController?.pushViewController(userDetailViewController, animated: true)
    }
}
