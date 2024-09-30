//
//  AgeRequest.swift
//  SmartTrainer Watch App
//
//  Created by Anton Shcherbakov on 06.02.2024.
//

import SwiftUI
import Foundation
import CoreData

struct AgeRequestView: View {
    
    @State private var selectedAge: Int = UserDefaults.standard.integer(forKey: ConstantsEnum.settingsNames.userAge)
    @State private var showAgeView1 = true
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack(alignment: .center) {
            Text("Select your age")
                .font(.system(size: 20))
                .bold()
            Picker("", selection: $selectedAge, content: {
                            ForEach(0..<100) { age in
                                HStack {
                                    Spacer()
                                    Text("\(age)")
                                        .font(.system(size: 40))
                                        .tag(age)
                                    Spacer()
                                }.padding()
                            }
                        })
                        .pickerStyle(WheelPickerStyle())
                        .frame(width: 120)
//            NavigationLink(destination: SettingsView(), isActive: $showAgeView1) {
                            Button(action: {
                                // Handle selected age here

                                        UserDefaults.standard.setValue(selectedAge, forKey: ConstantsEnum.settingsNames.userAge)
                                        print(UserDefaults.standard.integer(forKey: ConstantsEnum.settingsNames.userAge))

                                showAgeView1 = true
                                self.presentationMode.wrappedValue.dismiss()
                            }) {
                                Text("Submit")
                            }
            }
        
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
    }
}

struct AgeRequestView_Previews: PreviewProvider {
    static var previews: some View {
        AgeRequestView()
    }
}


