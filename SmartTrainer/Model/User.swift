//
//  User.swift
//  SmartTrainerIOS
//
//  Created by Anton Shcherbakov on 24.09.2024.
//

import Foundation

struct User: Identifiable, Codable {
    let id: String
    var fullname: String
    var email: String
    var type: UserType
    var trainerid: String?
    
    var initials: String{
        let formatter = PersonNameComponentsFormatter()
        if let components = formatter.personNameComponents(from: fullname) {
            formatter.style = .abbreviated
            return formatter.string(from: components)
        }
        
        return ""
    }
}

extension User {
    static var MOCK_USER = User(id: NSUUID().uuidString, fullname: "Chicken Alfredo", email: "alfredo.chicken@gmail.com", type: .athlete, trainerid: "")
}
