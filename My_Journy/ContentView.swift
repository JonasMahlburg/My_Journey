//
//  ContentView.swift
//  My_Journy
//
//  Created by Jonas Mahlburg on 01.12.25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    
    @State private var showingAddScreen = false
    
    var journeys = [Journey]()

    
    var body: some View {
        NavigationStack{
            List{
                ForEach (journeys) { journey in
                    NavigationLink( value: journey){
                        HStack{
                            Image(systemName: "car")
                            Text("From: \(journey.start) -> to: \(journey.destination)")
                        }
                    }
                    
                }
            }
                .navigationTitle("Meine Reisen")
                .toolbar{
                    Button("Add Samples", systemImage: "plus"){
                        showingAddScreen = true
                    }
                }
                .sheet(isPresented: $showingAddScreen) {
                    NewJourneyView()
                }
        }
        .frame(width: 300, height: 300)
        .background(.leatherBrown)
    }
}

#Preview {
    ContentView()
}
