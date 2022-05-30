//
//  ReadViewController.swift
//  KeychainDemo
//
//  Created by Слава Платонов on 25.05.2022.
//

import UIKit

class ReadViewController: UIViewController {
    
    let cacheService = CacheUserService()
    var users: [User] = []

    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUsers()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func loadUsers() {
        let usersFromCache = cacheService.getUsersFromCache()
        self.users = usersFromCache
    }
    
    private func getFullDescriptionOf(user: User, by indexPath: IndexPath) -> String {
        return "User №\(indexPath.row + 1): \(user.name), \(user.password), \(user.email), \(user.phone)"
    }
}

extension ReadViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let user = users[indexPath.row]
        var content = cell.defaultContentConfiguration()
        content.text = getFullDescriptionOf(user: user, by: indexPath)
        content.secondaryText = "secret passport - \(user.passport)"
        cell.contentConfiguration = content
        return cell
    }
}
