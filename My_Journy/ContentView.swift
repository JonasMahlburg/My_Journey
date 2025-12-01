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
    
    var body: some View {
        NavigationStack{
            DetailView()
                .navigationTitle("")
                .toolbar{
                    Button("Add Samples", systemImage: "plus"){
                        try? modelContext.delete(model: Journey.self)
                    }
                }
        }
    }
}

#Preview {
    ContentView()
}
