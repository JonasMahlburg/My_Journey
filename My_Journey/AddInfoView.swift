//
// AddInfoView.swift
// My_Journy
//
// Created by Jonas Mahlburg on 03.12.25.
//

import SwiftUI
import SwiftData

struct AddInfoView: View {
    @Bindable var journey: Journey
    @State private var newInfo = ""
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                TextEditor(text: $newInfo)
                    .frame(height: 100)
                    .border(Color.gray)
                    .padding()
                
                Button("Info hinzufügen") {
                    addInfo()
                }
                .padding()
                .buttonStyle(.borderedProminent)
                
                Spacer()
            }
            .navigationTitle("Neue Info")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Abbrechen") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    func addInfo() {
        guard !newInfo.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return
        }
        
        if journey.infos == nil {
            journey.infos = []
        }
        journey.infos?.append(newInfo)
                
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
    
    let sample = Journey(
        destination: "London",
        startDate: .now,
        vehicle: "Plane",
        infos: [
            "Good airplane food",
            "Looking for London Tower"
        ],
        start: "Berlin"
    )
    
    container.mainContext.insert(sample)
    
    return AddInfoView(journey: sample)
        .modelContainer(container)
}
