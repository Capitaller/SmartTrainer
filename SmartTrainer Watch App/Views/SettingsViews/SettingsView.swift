//
//  SettingsView.swift
//  SmartTrainer Watch App
//
//  Created by Anton Shcherbakov on 20.04.2024.
//

import SwiftUI

struct SettingsView: View {
    @State private var showAgeView = false
    @State private var showDistanceView = false
    @State private var showInfoView = false
    @State private var showDeleteDataView = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 10) {
                //Text("Settings").font(.system(size: 20))
                HStack(spacing: 10) {
                    
                    NavigationLink(destination: AgeRequestView(), isActive: $showAgeView) {
                        Button(action: {
                            showAgeView = true
                        }) {
                            Circle()
                                .foregroundColor(.blue)
                                .frame(width: 60, height: 60)
                                .overlay(
                                    Image(systemName: "person")
                                        .foregroundColor(.white)
                                        .font(.system(size: 30))
                                )
                                
                        }.buttonStyle(PlainButtonStyle())
                    }
                    
                    NavigationLink(destination: DistanceView(), isActive: $showDistanceView) {
                        Button(action: {
                            showDistanceView = true
                        }) {
                            Circle()
                                .foregroundColor(.yellow)
                                .frame(width: 60, height: 60)
                                .overlay(
                                    Image(systemName: "ruler")
                                        .foregroundColor(.white)
                                        .font(.system(size: 30))
                                        .tint(.yellow)
                                )
                        }
                        
                        
                    }.buttonStyle(PlainButtonStyle())
                }.buttonStyle(PlainButtonStyle())
                
                HStack(spacing: 10) {
                    NavigationLink(destination: InfoView(), isActive: $showInfoView) {
                        Button(action: {
                            showInfoView = true
                        }) {
                            Circle()
                                .foregroundColor(.green)
                                .frame(width: 60, height: 60)
                                .overlay(
                                    Image(systemName: "questionmark")
                                        .foregroundColor(.white)
                                        .font(.system(size: 30))
                                )
                        }
                    }.buttonStyle(PlainButtonStyle())
                    
                    NavigationLink(destination: DeleteDataView(), isActive: $showDeleteDataView) {
                        Button(action: {
                            showDeleteDataView = true
                        }) {
                            Circle()
                                .foregroundColor(.red)
                                .frame(width: 60, height: 60)
                                .overlay(
                                    Image(systemName: "xmark.bin")
                                        .foregroundColor(.white)
                                        .font(.system(size: 30))
                                )
                        }
                    }.buttonStyle(PlainButtonStyle())
                    
                }.buttonStyle(PlainButtonStyle())
            }
            .padding()
            //.navigationBarTitle("Settings")
            
        }.navigationBarTitle("Settings")
        
    }
}


struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
