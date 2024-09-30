//
//  SecureUD.swift
//  SmartTrainer Watch App
//
//  Created by Anton Shcherbakov on 14.05.2024.
//

import Foundation

class SecureUD {
    func set(_ value: Any?, forKey key: String) {
        guard let data = value as? Data else { return }
        saveToKeychain(key: key, data: data)
    }
    
    func object(forKey key: String) -> Any? {
        guard let data = loadFromKeychain(key: key) else { return nil }
        return data
    }
    func saveToKeychain(key: String, data: Data) {
        let query = [
            kSecClass as String: kSecClassGenericPassword as String,
            kSecAttrAccount as String: key,
            kSecValueData as String: data] as CFDictionary
        
        SecItemDelete(query)
        
        let status = SecItemAdd(query, nil)
        guard status == errSecSuccess else { return }
    }
    func loadFromKeychain(key: String) -> Data? {
        let query = [
            kSecClass as String: kSecClassGenericPassword as String,
            kSecAttrAccount as String: key,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne] as CFDictionary
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query, &dataTypeRef)
        guard status == errSecSuccess else { return nil }
        
        return dataTypeRef as? Data
    }

}



