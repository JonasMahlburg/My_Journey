//
//  PackingList.swift
//  My_Journy
//
//  Created by Jonas Mahlburg on 02.12.25.
//
import SwiftUI
import SwiftData

struct PackingList: View {
    @Bindable var journey: Journey
    
    @State private var items: [String] = ["Reisepass", "Zahnbürste", "Ladekabel"]
    @State private var newItemText: String = ""
    
    private var bindingPackList: Binding<[String]> {
            Binding(
                get: { journey.packlist ?? [] },
                set: { journey.packlist = $0 }
            )
        }
    
    var body: some View {
        NavigationView {
            VStack {
                Section {
                    HStack {
                        // 3. TextField mit Binding zum newItemText State
                        TextField("Was möchtest du mitnehmen?", text: $newItemText)
                            .textFieldStyle(.roundedBorder)
                        
                        // Button zum Hinzufügen des neuen Elements
                        Button {
                            addItem()
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .font(.title)
                        }
                        // Deaktiviere den Button, wenn das Eingabefeld leer ist
                        .disabled(newItemText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    }
                    .padding([.horizontal, .top])
                } header: {
                    Text("Neuen Gegenstand hinzufügen")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.leading)
                }
                
                // Sektion für die Anzeige der Packliste
                Section {
                    List {
                        // Zeige alle Elemente in der Liste an
                        ForEach(items, id: \.self) { item in
                            Text(item)
                        }
                        // Option, Elemente per Wischen zu löschen
                        .onDelete(perform: deleteItems)
                    }
                } header: {
                    Text("Packliste")
                        .font(.headline)
                        .padding(.leading)
                }
                Spacer()
            }
            .navigationTitle("Packliste 🎒")
            .toolbar {
                // Füge den Edit Button hinzu, um den onDelete Button freizuschalten
                EditButton()
            }
        }
    }
    
    // Funktion zum Hinzufügen eines Elements
    func addItem() {
        let trimmedItem = newItemText.trimmingCharacters(in: .whitespacesAndNewlines)
        // Füge das Element hinzu, wenn es nicht leer ist
        if !trimmedItem.isEmpty {
            items.append(trimmedItem)
            newItemText = "" // Setze das Eingabefeld zurück
        }
    }
    
    // Funktion zum Löschen von Elementen
    func deleteItems(offsets: IndexSet) {
        items.remove(atOffsets: offsets)
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
            destination: "New York",
            startDate: .now,
            vehicle: "Plane",
            start: "Berlin"
        )
        
        container.mainContext.insert(sample)
        
        return PackingList(journey: sample)
            .modelContainer(container)
}
