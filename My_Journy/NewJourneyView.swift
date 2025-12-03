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
                    // Bindung der Textfelder direkt an das newJourney Objekt
                    TextField("Start", text: $newJourney.start)
                    TextField("Destination", text: $newJourney.destination)
                    
                    DatePicker("Start of Journey", selection: $newJourney.startDate)
                    
                    // Korrektes Binding für den Picker:
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
                        // Der Zugriff auf newJourney ist hier nun direkt möglich
                        saveJourney()
                    }
                    // Prüfe auf Start und Destination in der newJourney
                    .disabled(newJourney.start.isEmpty || newJourney.destination.isEmpty)
                }
                
                ToolbarItem(placement: .bottomBar) {
                    // NavigationLink zur Packliste, Übergabe der newJourney
                    NavigationLink {
                        // Die PackingList benötigt das @Bindable Journey-Objekt
                        PackingList(journey: newJourney)
                    } label: {
                        Label("Packliste", systemImage: "checklist")
                    }
                }
            }
        }
    }
    
    // 2. KORRIGIERT: Die Funktion greift jetzt direkt auf die @State Variable zu
    func saveJourney() {
        // Die Packliste wurde bereits in newJourney gespeichert.
        // Wir fügen das Objekt einfach in den ModelContext ein.
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
