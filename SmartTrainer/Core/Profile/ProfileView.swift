//
//  ProfileView.swift
//  SmartTrainerIOS
//
//  Created by Anton Shcherbakov on 22.09.2024.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var trainerID = ""  // State variable to hold the editable Trainer ID
    @State private var isEditingTrainerID = false  // Track whether we are editing the Trainer ID
    
    var body: some View {
        if let user = viewModel.currentUser {
            List {
                Section {
                    HStack {
                        Text(user.initials)
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                            .frame(width: 72, height: 72)
                            .background(Color(.systemGray3))
                            .clipShape(Circle())
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(user.fullname)
                                .font(.subheadline)
                                .fontWeight(.semibold)
                                .padding(.top, 4)
                            
                            Text(user.email)
                                .font(.footnote)
                                .foregroundColor(.gray)
                            if user.type == .trainer {
                                Text(user.id)
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                                    .contextMenu {
                                        Button(action: {
                                            UIPasteboard.general.string = user.id
                                        }) {
                                            Label("Copy ID", systemImage: "doc.on.doc")
                                        }
                                    }
                            }
                            
                        }
                    }
                }
                
                Section("General") {
                    HStack{
                        SettingsRowView(imageName: "figure.strengthtraining.functional.circle", title: "Account Type", tintColor: Color(.systemGray))
                        
                        Spacer()
                        
                        Text(user.type.displayName)  // Display the user type (Athlete/Trainer)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    HStack{
                        SettingsRowView(imageName: "gear", title: "Version", tintColor: Color(.systemGray))
                        
                        Spacer()
                        
                        Text("0.0.0.1")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                
                // Editable Trainer ID Section
                if user.type == .athlete {
                    Section("Trainer") {
                        HStack {
                            SettingsRowView(imageName: "list.bullet.clipboard", title: "Trainer Id", tintColor: Color(.systemGray))
                            
                            Spacer()
                            
                            if isEditingTrainerID {
                                TextField("Enter Trainer ID", text: $trainerID)
                                    .font(.subheadline)
                                    .foregroundColor(.primary)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .frame(maxWidth: 150)  // Adjust the width if needed
                            } else {
                                Text(user.trainerid ?? "")
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                        
                        // Toggle Edit/Save button
                        Button {
                            if isEditingTrainerID {
                                // Save the Trainer ID to Firebase
                                Task {
                                    try await viewModel.updateTrainerID(newTrainerID: trainerID)
                                }
                            } else {
                                // Set the current Trainer ID in the text field when editing starts
                                trainerID = user.trainerid ?? ""
                            }
                            isEditingTrainerID.toggle()  // Toggle between edit and view mode
                        } label: {
                            Text(isEditingTrainerID ? "Save" : "Edit Trainer ID")
                                .fontWeight(.semibold)
                        }
                    }
                }
            
                
                Section("Account") {
                    Button {
                        viewModel.signOut()
                    } label: {
                        SettingsRowView(imageName: "arrow.left.circle.fill", title: "Sign Out", tintColor: Color(.red))
                    }
                    
                    Button {
                        print("Deleting Account...")
                    } label: {
                        SettingsRowView(imageName: "xmark.circle.fill", title: "Delete Account", tintColor: Color(.red))
                    }
                    
                }
            }
        }
    }
}

#Preview {
    ProfileView()
}
