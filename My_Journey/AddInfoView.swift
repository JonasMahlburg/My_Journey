//
// AddInfoView.swift
// My_Journy
//
// Created by Jonas Mahlburg on 03.12.25.
//

import SwiftUI
import SwiftData

struct AddInfoView: View {
    // 1. Journey als @Bindable, um die Infos zu ändern
    @Bindable var journey: Journey
    // 2. State für die Texteingabe
    @State private var newInfo = ""
    // 3. Environment-Variable, um das Sheet zu schließen
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
            return // Füge keine leeren Strings hinzu
        }
        
        // Füge die neue Info zum Array hinzu
        if journey.infos == nil {
            journey.infos = []
        }
        journey.infos?.append(newInfo)
        
        // Speichern ist bei @Bindable in SwiftData automatisch (da @Model)
        
        dismiss() // Schließe das Sheet
    }
}

#Preview {
    let container: ModelContainer
    do {
        // Sicherstellen, dass der Container für das Journey Model erstellt wird
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
    
    // ⚠️ KORREKTUR: Muss AddInfoView anstelle von DetailView zurückgeben
    return AddInfoView(journey: sample)
        .modelContainer(container) // Füge den Container zur Preview hinzu
}
