//
//  InfoView.swift
//  SmartTrainer Watch App
//
//  Created by Anton Shcherbakov on 08.05.2024.
//

import SwiftUI

struct InfoView: View {
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        ScrollView {
            VStack(alignment: .center) {
                Text(ConstantsEnum.info.info1)
                Text(ConstantsEnum.info.infoWarning).foregroundColor(.red)
                Text(ConstantsEnum.info.info2)
                Button(action: {
                    
                    self.presentationMode.wrappedValue.dismiss()
                }) {
                    Text("Ok")
                    
                }
            }
        }
    }
}

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView()
    }
}
