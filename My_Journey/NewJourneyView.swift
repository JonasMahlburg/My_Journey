//
// NewJourneyView.swift
// My_Journy
//
// Created by Jonas Mahlburg on 01.12.25.
//

import SwiftUI
import SwiftData

struct NewJourneyView: View {
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) var dismiss

    @State private var newJourney = Journey(
        destination: "",
        startDate: Date(),
        vehicle: VehicleType.car.rawValue,
        start: ""
    )
    
    var body: some View {
        NavigationStack {
            Form{
                Section("Travel Plan"){
                    TextField("Start", text: $newJourney.start)
                    TextField("Destination", text: $newJourney.destination)
                    
                    DatePicker("Start of Journey", selection: $newJourney.startDate)
                    
                    Picker("Vehicle", selection: Binding(
                        get: { newJourney.vehicleType ?? VehicleType.car },
                        set: { newJourney.vehicle = $0.rawValue }
                    )) {
                        ForEach(VehicleType.allCases){ type in
                            Text(type.displayName)
                                .tag(type)
                        }
                    }
                    .pickerStyle(.menu)
                }
            }
            .navigationTitle("Neue Reise hinzufügen")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Abbrechen") { dismiss() }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Speichern") {
                        saveJourney()
                    }
                    .disabled(newJourney.start.isEmpty || newJourney.destination.isEmpty)
                }
                
                ToolbarItem(placement: .bottomBar) {
                    NavigationLink {
                        PackingList(journey: newJourney)
                    } label: {
                        Label("Packliste", systemImage: "checklist")
                    }
                }
            }
        }
    }
    
    func saveJourney() {
        modelContext.insert(newJourney)
        
        dismiss()
    }
}

#Preview {
    let container: ModelContainer
        do {
            container = try ModelContainer(for: Journey.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
        
        return NewJourneyView()
            .modelContainer(container)
}
