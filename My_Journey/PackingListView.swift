//
// PackingListView.swift
// My_Journy
//
// Created by Jonas Mahlburg on 02.12.25.
//
import SwiftUI
import SwiftData

struct PackingList: View {
    @Bindable var journey: Journey
    
    @State private var newItemText: String = ""
    @State private var isPacked: Bool = false
    
    private var vehicleIcon: String {
        journey.vehicleType?.iconName ?? "questionmark.circle"
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Section {
                    HStack {
                        TextField("Was möchtest du mitnehmen?", text: $newItemText)
                            .textFieldStyle(.roundedBorder)
                        
                        Button {
                            addItem()
                        } label: {
                            Image(systemName: "plus.circle.fill")
                                .font(.title)
                        }
                        .disabled(newItemText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    }
                    .padding([.horizontal, .top])
                } header: {
                    Text("Neuen Gegenstand hinzufügen")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.leading)
                }
                
                Section {
                    List {
                        ForEach(journey.packlist ?? [], id: \.self) { item in
                            Toggle(isOn: $isPacked) {
                                Text(item)
                            }
                        }
                        .onDelete(perform: deleteItems)
                    }
                } header: {
                    HStack {
                        Image(systemName: vehicleIcon)
                        Text("Packliste für \(journey.destination)")
                    }
                    .font(.headline)
                    .padding(.leading)
                }
                
                Spacer()
            }
            .navigationTitle("Packliste 🎒")
            .toolbar {
                EditButton()

            }
        }
    }
    
    func addItem() {
        let trimmedItem = newItemText.trimmingCharacters(in: .whitespacesAndNewlines)
        if !trimmedItem.isEmpty {
            if journey.packlist == nil {
                journey.packlist = []
            }
            journey.packlist?.append(trimmedItem)
            isPacked = true
            
            newItemText = ""
        }
    }
    
    func deleteItems(offsets: IndexSet) {
        journey.packlist?.remove(atOffsets: offsets)
    }
    
}
