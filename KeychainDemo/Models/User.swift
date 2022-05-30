//
//  User.swift
//  KeychainDemo
//
//  Created by Слава Платонов on 30.05.2022.
//

import Foundation

struct User: Codable, Hashable {
    let name: String
    let password: String
    let email: String
    var passport: String
    let phone: String
    
    var data: Data {
        guard let data = try? JSONEncoder().encode(self) else { return Data() }
        return data
    }
    
    var key: String {
        return "\(name)-\(email)"
    }
    
    init(name: String, password: String, email: String, passport: String, phone: String) {
        self.name = name
        self.password = password
        self.email = email
        self.passport = passport
        self.phone = phone
    }
    
    init?(data: Data) {
        guard let info = try? JSONDecoder().decode(User.self, from: data) else { return nil }
        self = info
    }
}
