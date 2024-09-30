//
//  DeleteDataView.swift
//  SmartTrainer Watch App
//
//  Created by Anton Shcherbakov on 08.05.2024.
//

import SwiftUI

struct DeleteDataView: View {
    // Binding to the data that will be deleted

    
    // Binding to the flag that indicates whether the user has confirmed the deletion
    @State private var confirmedDeletion = false
    
    @State private var sliderValue: Double = 0
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        
        VStack {
            Text("You are going to delete all collected data!").padding()
 
            Toggle("Are you sure?",isOn: $confirmedDeletion )
                .toggleStyle(SwitchToggleStyle(tint: .red))
            .accentColor(confirmedDeletion ? .green : .red)
            .frame(width: 150)

            if (confirmedDeletion) {
                Button(action: {
                    if confirmedDeletion {
                        let db = DBManager()
                        
                        db.deleteData()
                        print("deleteData")
                        
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }) {
                    Text("Delete")
                        .cornerRadius(10)
                }
                .disabled(!confirmedDeletion)
                .tint(.red)
                .padding()
            }
            else
            {
                Button(action: {
                    if !confirmedDeletion {
                        print("cancel")
                        self.presentationMode.wrappedValue.dismiss()
                    }
                }) {
                    Text("Cancel")
                        .cornerRadius(10)
                }
                .padding()
            }
            
        }
    }
}

struct DeleteDataView_Previews: PreviewProvider {
    static var previews: some View {
        DeleteDataView()
    }
}

