//
//  RegistrationView.swift
//  SmartTrainerIOS
//
//  Created by Anton Shcherbakov on 22.09.2024.
//

import SwiftUI

struct RegistrationView: View {
    @State private var email = ""
    @State private var fullname = ""
    @State private var selectedUserType: UserType = .athlete  // Track the selected user type
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var trainerID = ""  // Trainer ID for athletes
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        VStack{
            Image(systemName: "figure.run.circle")
                .resizable()
                .scaledToFill()
                .frame(width: 130, height:150)
//                .offset(y: -3)
//                .padding(.vertical, 3)
            
            // form fields
            VStack(spacing: 15){
                InputView(text: $email,
                          title: "Email Address",
                          placeholder: "name@exmaple.com")
                .autocapitalization(.none)
                
                InputView(text: $fullname,
                          title: "Full Name",
                          placeholder: "Your Name")
                
                // Account Type Selection
                VStack(alignment: .leading) {
                    Text("Account Type")
                        .font(.footnote)

                    HStack {
                        Button(action: {
                            selectedUserType = .athlete}) {
                                Text("Athlete")
                                    .fontWeight(.semibold)
                                    .foregroundColor(selectedUserType == .athlete ? .white : .gray)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(selectedUserType == .athlete ? Color.blue : Color(.systemGray6))
                                    .cornerRadius(10)
                                       }
                                       
                        Button(action: {
                            selectedUserType = .trainer}) {
                                Text("Trainer")
                                    .fontWeight(.semibold)
                                    .foregroundColor(selectedUserType == .trainer ? .white : .gray)
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(selectedUserType == .trainer ? Color.blue : Color(.systemGray6))
                                    .cornerRadius(10)
                                       }
                                   }
                               }
                // Show Trainer ID field for Athlete
                                if selectedUserType == .athlete {
                                    InputView(text: $trainerID,
                                              title: "Trainer ID",
                                              placeholder: "Enter Trainer ID")
                                }
                    
                InputView(text: $password,
                          title: "Password",
                          placeholder: "Enter Password",
                          isSecureField: true)
                ZStack(alignment: .trailing) {
                    InputView(text: $confirmPassword,
                              title: "Confirm Password",
                              placeholder: "Confirm Your Password",
                              isSecureField: true)
                    
                    if !password.isEmpty && !confirmPassword.isEmpty {
                        if password == confirmPassword {
                            Image(systemName: "checkmark.circle.fill")
                                .imageScale(.large)
                                .fontWeight(.bold)
                                .foregroundStyle(Color(.systemGreen))
                        } else {
                            Image(systemName: "xmark.circle.fill")
                                .imageScale(.large)
                                .fontWeight(.bold)
                                .foregroundStyle(Color(.systemRed))
                        }
                    }
                }
            }
            .padding(.horizontal)
            .padding(.top, 12)
            
            // register button
            Button {
                Task {
                    try await viewModel.createUser(withEmail: email, password: password, fullname: fullname, userType: selectedUserType, trainerID: trainerID)
                }
            } label: {
                HStack{
                    Text("REGISTER")
                        .fontWeight(.semibold)
                    Image(systemName: "arrow.right")
                }
                .foregroundColor(.white)
                .frame(width: UIScreen.main.bounds.width - 32, height: 48)
            }
            .background(Color(.systemBlue))
            .disabled(!formIsValid)
            .opacity(formIsValid ? 1.0 : 0.5)
            .cornerRadius(10)
            .padding(.top, 24)
            
            Spacer()
            
            // sign-in link
            Button{
                dismiss()
            } label: {
                HStack(spacing: 4) {
                    Text("Already have an account?")
                    Text("Sign In")
                        .fontWeight(.bold)
                }
                .font(.system(size: 16))
            }
        }
    }
}

// MARK: - AuthenticationFormProtocol

extension RegistrationView: AuthenticationFormProtocol {
    var formIsValid: Bool {
        return !email.isEmpty
        && email.contains("@")
        && !password.isEmpty
        && password.count > 5
        && confirmPassword == password
        && !fullname.isEmpty
    }
}

#Preview {
    RegistrationView()
}
