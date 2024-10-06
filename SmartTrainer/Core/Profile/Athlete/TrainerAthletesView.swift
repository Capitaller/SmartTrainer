//
//  TrainerAthletesView.swift
//  SmartTrainer
//
//  Created by Anton Shcherbakov on 06.10.2024.
//

import SwiftUI

struct TrainerAthletesView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        VStack {
            if viewModel.athletes.isEmpty {
                Text("No athletes assigned to you.")
                    .foregroundColor(.gray)
                    .padding()
            } else {
                List(viewModel.athletes) { athlete in
                    Section {
                        HStack {
                            // Display initials in a circle
                            Text(athlete.initials)
                                .font(.title)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .frame(width: 72, height: 72)
                                .background(Color(.systemGray3))
                                .clipShape(Circle())
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(athlete.fullname)
                                    .font(.subheadline)
                                    .fontWeight(.semibold)
                                    .padding(.top, 4)
                                
                                Text(athlete.email)
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
                .listStyle(InsetGroupedListStyle())  // Optional styling
            }
        }
        .onAppear {
            Task {
                await viewModel.fetchAthletes()  // Fetch athletes when view appears
            }
        }
        .navigationTitle("Your Athletes")
    }
}

#Preview {
    TrainerAthletesView()
        .environmentObject(AuthViewModel())
}
