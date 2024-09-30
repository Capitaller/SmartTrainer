//
//  AuthViewModel.swift
//  SmartTrainer
//
//  Created by Anton Shcherbakov on 24.09.2024.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore

protocol AuthenticationFormProtocol {
    var formIsValid: Bool { get }
}

//@MainActor
class AuthViewModel: ObservableObject {
    // checks if we already have a user signed in or not,
    // determines login screen or home screen
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    
    init() {
        self.userSession = Auth.auth().currentUser
        
        Task {
            await fetchUser()
        }
    }
    
    func signIn(withEmail email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            
            DispatchQueue.main.async {
                        self.userSession = result.user
                    }
            await fetchUser()
        } catch {
            print("DEBUG: Failed to log in with error: \(error.localizedDescription)")
        }
    }
    
    func createUser(withEmail email: String, password: String, fullname: String, userType: UserType) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            DispatchQueue.main.async {
                self.userSession = result.user
            }
            let user = User(id: result.user.uid, fullname: fullname, email: email, type: userType)
            let encodedUser = try Firestore.Encoder().encode(user)
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser)
            await fetchUser()
        } catch {
            print("DEBUG: failed to create user with error: \(error.localizedDescription)")
        }
    }
    
    func signOut() {
        do {
            // fire base code that signs user out on back end
            try Auth.auth().signOut()
            // reset user session that will then take us back to log-in screen
            self.userSession = nil
            // reset our current user data model
            self.currentUser = nil

        } catch {
            print("DEBUG: failed to sign user out with error: \(error.localizedDescription)")
        }
    }
    
    func deleteAccount() {
        
    }
    
    func fetchUser() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else { return }
        DispatchQueue.main.async {
            self.currentUser = try? snapshot.data(as: User.self)
        }
    }
}
