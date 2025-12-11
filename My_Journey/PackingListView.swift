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
                    if let packlist = journey.packlist, packlist.isEmpty {
                        Spacer()
                        Text("Ich packe meinen Koffer mit...")
                        Spacer()
                    }else{
                        List {
                            ForEach(Array((journey.packlist ?? []).enumerated()), id: \.element.id) { index, item in
                                Toggle(isOn: Binding(
                                    get: {
                                        if let list = journey.packlist, list.indices.contains(index) {
                                            return list[index].isPacked
                                        }
                                        return false
                                    },
                                    set: { newValue in
                                        if journey.packlist == nil { journey.packlist = [] }
                                        if let list = journey.packlist, list.indices.contains(index) {
                                            list[index].isPacked = newValue
                                            journey.packlist = list
                                        }
                                    }
                                )) {
                                    Text(item.name)
                                }
                            }
                            .onDelete(perform: deleteItems)
                        }
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
            if journey.packlist == nil { journey.packlist = [] }
            journey.packlist?.append(PackItem(name: trimmedItem, isPacked: false))
            newItemText = ""
        }
    }

    func deleteItems(offsets: IndexSet) {
        if journey.packlist == nil { return }
        journey.packlist?.remove(atOffsets: offsets)
    }
    
}
