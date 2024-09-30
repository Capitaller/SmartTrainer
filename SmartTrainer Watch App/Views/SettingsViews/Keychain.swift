//
//  Keychain.swift
//  SmartTrainer Watch App
//
//  Created by Anton Shcherbakov on 14.05.2024.
//

import Foundation
import Security

class Keychain
{
    func saveToKeychain(key: String, data: Data) {
        let query = [
            kSecClass as String: kSecClassGenericPassword as String,
            kSecAttrAccount as String: key,
            kSecValueData as String: data] as CFDictionary
        
        SecItemDelete(query)
        
        let status = SecItemAdd(query, nil)
        guard status == errSecSuccess else { return }
    }
}
