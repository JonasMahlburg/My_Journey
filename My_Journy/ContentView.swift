//
// ContentView.swift
// My_Journy
//
// Created by Jonas Mahlburg on 01.12.25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    
    @State private var showingAddScreen = false
    
    @Query(sort: \Journey.startDate, order: .forward) var journeys: [Journey]

    
    var body: some View {
        NavigationStack{
            List{
                ForEach (journeys) { journey in
                    NavigationLink(value: journey) {
                        HStack{
                            Image(systemName: journey.vehicleType?.iconName ?? "car")
                            VStack(alignment: .leading) {
                                Text("\(journey.start) → \(journey.destination)")
                                    .font(.headline)
                                Text(journey.startDate, style: .date)
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
            }
                .navigationTitle("Meine Reisen")
                .toolbar{
                    Button("Reise hinzufügen", systemImage: "plus"){
                        showingAddScreen = true
                    }
                }
                .sheet(isPresented: $showingAddScreen) {
                    NewJourneyView()
                }
                .navigationDestination(for: Journey.self) { journey in
                    VStack(alignment: .leading, spacing: 12) {
                        Text("\(journey.start) → \(journey.destination)")
                            .font(.title2)
                            .bold()
                        Text(journey.startDate, style: .date)
                            .font(.headline)
                            .foregroundStyle(.secondary)
                        if let vehicle = journey.vehicleType?.iconName {
                            Label("Fahrzeug", systemImage: vehicle)
                        }
                        Spacer()
                    }
                    .padding()
                    .navigationTitle("Reise")
                }
        }

    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Journey.self, configurations: config)
        
        container.mainContext.insert(Journey(destination: "Berlin", startDate: Date().addingTimeInterval(86400), vehicle: VehicleType.train.rawValue, start: "München"))
        
        return ContentView()
            .modelContainer(container)
    } catch {
        return Text("Failed to create container: \(error.localizedDescription)")
    }
}

