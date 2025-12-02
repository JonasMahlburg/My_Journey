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
    
    @State private var start = ""
    @State private var destination = ""
    @State private var startDate = Date()
    @State private var selectedVehicle = VehicleType.car
    
    var body: some View {
        NavigationStack {
            Form{
                Section("Travel Plan"){
                    TextField("Start", text: $start)
                    TextField("Destination", text: $destination)
                    
                    DatePicker("Start of Journey", selection: $startDate)
                    
                    Picker("Vehicle", selection: $selectedVehicle){
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
                        saveJourney() // Neue Funktion zum Speichern aufrufen
                    }
                    // Speichern-Button nur aktivieren, wenn Start und Ziel eingegeben wurden
                    .disabled(start.isEmpty || destination.isEmpty)
                }
                
                // NavigationLink am unteren Rand, falls benötigt (platziere ihn hier oder im Form)
                ToolbarItem(placement: .bottomBar) {
                    NavigationLink {
                        // PackingList() // Sicherstellen, dass PackingList existiert und importiert ist
                        Text("Packliste-View")
                    } label: {
                        Label("Packliste", systemImage: "checklist")
                    }
                }
            }
        }
    }
    
    // Funktion zum Speichern der neuen Journey
    func saveJourney() {
        // 1. Neue Journey Instanz erstellen
        let newJourney = Journey(
            destination: destination,
            stops: nil,
            startDate: startDate,
            vehicle: selectedVehicle.rawValue,
            infos: nil,
            start: start  // Standardwert
        )
        
        // 2. Im ModelContext speichern
        modelContext.insert(newJourney)
        
        // 3. View schließen
        dismiss()
    }
}
