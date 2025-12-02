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
                        saveJourney()
                    }
                    .disabled(start.isEmpty || destination.isEmpty)
                }
                
                ToolbarItem(placement: .bottomBar) {
                    NavigationLink {
                        Text("Packliste-View")
                    } label: {
                        Label("Packliste", systemImage: "checklist")
                    }
                    EditButton()
                }
            }
        }
    }
    
    func saveJourney() {
        let newJourney = Journey(
            destination: destination,
            stops: nil,
            startDate: startDate,
            vehicle: selectedVehicle.rawValue,
            infos: nil,
            start: start  // Standardwert
        )
        modelContext.insert(newJourney)
        
        dismiss()
    }
}
