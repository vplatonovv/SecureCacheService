//
//  CacheUserService.swift
//  KeychainDemo
//
//  Created by Слава Платонов on 25.05.2022.
//

import Foundation

protocol DefaultCacheService: AnyObject {
    func addUserToCache(_ user: User)
    func getUsersFromCache() -> [User]
    func deleteAll() -> Bool
}

final class CacheUserService: DefaultCacheService {
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
                guard let result = try? keychainHelper.save(value: user.passport, forKey: keyForKeychain) else {
                    return
                }
                print("ADD TO CACHE WITH RESULT - \(result)")
            }
        } else {
            UserDefaults.standard.set([data], forKey: "key")
            guard let result = try? keychainHelper.save(value: user.passport, forKey: keyForKeychain) else {
                return
            }
            print("ADD TO CACHE WITH RESULT - \(result)")
        }
    }
    
    func getUsersFromCache() -> [User] {
        var users: [User] = []
        if let cachedUsers = UserDefaults.standard.object(forKey: "key") as? [Data] {
            cachedUsers.forEach { cachedUser in
                if var user = User(data: cachedUser) {
                    guard let passport = try? keychainHelper.read(forKey: user.key) else {
                        return
                    }
                    user.passport = passport
                    users.append(user)
                }
            }
        } else {
            print("empty")
        }
        return users
    }
    
    func deleteAll() -> Bool {
        UserDefaults.standard.removeObject(forKey: "key")
        guard let result = try? keychainHelper.clearAll() else { return false }
        return result
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
