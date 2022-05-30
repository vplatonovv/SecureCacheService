//
//  CacheUserService.swift
//  KeychainDemo
//
//  Created by Слава Платонов on 25.05.2022.
//

import Foundation

protocol _CacheUserService: AnyObject {
    func addUserToCache(_ user: User)
    func getUsersFromCache() -> [User]
}

// TODO: Remove force cast!

final class CacheUserService: _CacheUserService {
    private let userDefaults: UserDefaults = UserDefaults.standard
    private let keychainHelper: KeychainHelper = KeychainHelper()
    
    func addUserToCache(_ user: User) {
        var _user = user
        _user.passport = "secret"
        let data = _user.data
        let keyForKeychain = _user.key
        
        if var cachedUsersData = UserDefaults.standard.object(forKey: "key") as? [Data] {
            if !existUserInCache(_user) {
                cachedUsersData.append(data)
                UserDefaults.standard.set(cachedUsersData, forKey: "key")
                keychainHelper.save(value: user.passport, forKey: keyForKeychain)
            }
        } else {
            UserDefaults.standard.set([data], forKey: "key")
            keychainHelper.save(value: user.passport, forKey: keyForKeychain)
        }
    }
    
    func getUsersFromCache() -> [User] {
        var users: [User] = []
        if let cachedUsers = UserDefaults.standard.object(forKey: "key") as? [Data] {
            cachedUsers.forEach { cachedUser in
                var user = User(data: cachedUser)
                let passport = keychainHelper.read(forKey: user!.key)
                user?.passport = passport
                users.append(user!)
            }
        } else {
            print("something wrong")
        }
        return users
    }
    
    private func existUserInCache(_ user: User) -> Bool {
        var result: Bool = false
        if let cachedUsersData = UserDefaults.standard.object(forKey: "key") as? [Data] {
            let cachedUsers = cachedUsersData.map { User(data: $0) }
            if cachedUsers.contains(user) {
                result = true
            }
        }
        return result
    }
}
