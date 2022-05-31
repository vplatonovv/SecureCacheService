//
//  KeychainHelper.swift
//  KeychainDemo
//
//  Created by Слава Платонов on 30.05.2022.
//

import Foundation

protocol _KeychainHelper: AnyObject {
    func save(value: String, forKey: String)
    func read(forKey: String) -> String
}

// TODO: Error throws in keychain helper, return bools for keychain methods

final public class KeychainHelper: _KeychainHelper {
    
    enum KeychainErrors {
        
    }
        
    func save(value: String, forKey: String) {
        guard let data = value.data(using: .utf8) else { return }
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: forKey,
            kSecValueData as String: data
        ]
        
        let status = SecItemAdd(query as CFDictionary, nil)
        guard status == 0 else {
            print("😢😢😢 SAVE ERROR")
            print(SecCopyErrorMessageString(status, nil)!)
            return
        }
        print("🔥🔥🔥 saved to keychain")
    }
    
    func read(forKey: String) -> String {
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
            print("😢😢😢 item not found")
            return ""
        }
        guard status == errSecSuccess else {
            print("😢😢😢 bad access")
            print(SecCopyErrorMessageString(status, nil)!)
            return ""
        }
        guard let existingItem = item as? [String : Any],
              let secureValue = existingItem[kSecValueData as String] as? Data,
              let passport = String(data: secureValue, encoding: .utf8) else {
            print("😢😢😢 cannot converte")
            print(SecCopyErrorMessageString(status, nil)!)
            return ""
        }
        print("🔥🔥🔥 read from keychain")
        return passport
    }
    
    func clearAll() -> Bool {
        let query: [String: Any] = [kSecClass as String : kSecClassGenericPassword]
        let status = SecItemDelete(query as CFDictionary)
        guard status == 0 else {
            print("😢😢😢 cannot to delete all values")
            return false
        }
        return status == noErr
    }
}
