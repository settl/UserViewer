//
//  UserDetailViewController.swift
//  UserViewer
//
//  Created by Sophie on 12.11.17.
//  Copyright © 2017 soet. All rights reserved.
//

import UIKit
import MessageUI

class UserDetailViewController: UIViewController {
    var user: User
    var userViewModel: UserViewModel
    let tableView = UITableView()
    let nameAndImageCellHeight: CGFloat = 250
    let regularCellHeight: CGFloat = 50

    init(user: User) {
        self.user = user
        self.userViewModel = UserViewModel(user: self.user)
        super.init(nibName:nil, bundle:nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        navigationController?.navigationBar.isTranslucent = false
        title = user.name
    }

    fileprivate func showMailComposeViewController() {
        guard MFMailComposeViewController.canSendMail() else {
            print("Your device is not configured to send emails.")
            return
        }
        let mailComposeViewController = MFMailComposeViewController()
        mailComposeViewController.mailComposeDelegate = self
        mailComposeViewController.setToRecipients([user.email])
        mailComposeViewController.setSubject("Hello \(user.name)!")

        present(mailComposeViewController, animated: true, completion: nil)
    }
}

extension UserDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userViewModel.items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = userViewModel.items[indexPath.row]
        switch item.type {
        case .nameAndImage:
            let cell = tableView.dequeueReusableCell(withIdentifier: UserImageCell.identifier, for: indexPath) as! UserImageCell
            cell.configure(item: item)
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: UserPropertyCell.identifier, for: indexPath) as! UserPropertyCell
            cell.configure(item: item)
            return cell
        }
    }
}

extension UserDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = userViewModel.items[indexPath.row]
        if item.type == .nameAndImage {
            return nameAndImageCellHeight
        }
        return regularCellHeight
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = userViewModel.items[indexPath.row]
        if item.type == .email {
            showMailComposeViewController()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension UserDetailViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
}

extension UserDetailViewController {
    fileprivate func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "UserImageCell", bundle: nil), forCellReuseIdentifier: UserImageCell.identifier)
        tableView.register(UserPropertyCell.self, forCellReuseIdentifier: UserPropertyCell.identifier)
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            ])
        tableView.tableFooterView = UIView(frame: .zero)
    }
}
