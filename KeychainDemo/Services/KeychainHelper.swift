//
//  KeychainHelper.swift
//  KeychainDemo
//
//  Created by Слава Платонов on 30.05.2022.
//

import Foundation

protocol _KeychainHelper: AnyObject {
    func save(value: String, forKey: String) throws -> Bool
    func read(forKey: String) throws -> String
    func clearAll() throws -> Bool
}

final public class KeychainHelper: _KeychainHelper {
    
    enum KeychainErrors: Error {
        case itemNotFound
        case badSuccess
        case badData
        case genericError(OSStatus)
    }
        
    func save(value: String, forKey: String) throws -> Bool {
        guard let data = value.data(using: .utf8) else { return false }
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: forKey,
            kSecValueData as String: data
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == 0 else {
            throw KeychainErrors.genericError(status)
        }
        print("🔥🔥🔥 saved to keychain")
        return status == noErr
    }
    
    func read(forKey: String) throws -> String {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: forKey,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnAttributes as String: true,
            kSecReturnData as String: true
        ]
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query as CFDictionary, &item)
        guard status != errSecItemNotFound else {
            throw KeychainErrors.itemNotFound
        }
        guard status == errSecSuccess else {
            throw KeychainErrors.badSuccess
        }
        guard let existingItem = item as? [String : Any],
              let secureValue = existingItem[kSecValueData as String] as? Data,
              let passport = String(data: secureValue, encoding: .utf8) else {
            throw KeychainErrors.badData
        }
        print("🔥🔥🔥 read from keychain")
        return passport
    }
    
    func clearAll() throws -> Bool {
        let query: [String: Any] = [kSecClass as String : kSecClassGenericPassword]
        let status = SecItemDelete(query as CFDictionary)
        guard status == 0 else {
            throw KeychainErrors.genericError(status)
        }
        return status == noErr
    }
}
