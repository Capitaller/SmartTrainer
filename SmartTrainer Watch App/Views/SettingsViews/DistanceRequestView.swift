//
//  DistanceView.swift
//  SmartTrainer Watch App
//
//  Created by Anton Shcherbakov on 20.04.2024.
//

import SwiftUI

struct DistanceView: View {
    @State private var selectedDistance: Int = UserDefaults.standard.integer(forKey: ConstantsEnum.settingsNames.userDistance)
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack(alignment: .center) {
                    Text("Select distance (m)")
                        .font(.system(size: 20))
                        .bold()
                    Picker("", selection: $selectedDistance, content: {
                        ForEach(1...1000, id: \.self) { distance in
                            let value = distance * 100
                            HStack {
                                Spacer()
                                Text("\(value)")
                                    .font(.system(size: 25))
                                    .tag(value)
                                Spacer()
                            }.padding()
                        }
                    })
                        .pickerStyle(WheelPickerStyle())
                        .frame(width: 120)
            Button(action: {
                UserDefaults.standard.setValue(selectedDistance, forKey: ConstantsEnum.settingsNames.userDistance)
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Text("Submit")
                
            }
        }
        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
    }
}

struct DistanceView_Previews: PreviewProvider {
    static var previews: some View {
        DistanceView()
    }
}
