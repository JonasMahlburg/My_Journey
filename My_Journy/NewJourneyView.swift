//
//  NewJourneyView.swift
//  My_Journy
//
//  Created by Jonas Mahlburg on 01.12.25.
//

import SwiftUI
import SwiftData

struct NewJourneyView: View {
    @Bindable var journey: Journey
    
    @State private var selectedVehicle: VehicleType = {
        if let type = VehicleType(rawValue: "car") {
            return type
        }
        return .car
    }()
    
    var body: some View {
        Form{
            Section("Travel Plan"){
                TextField("Start", text: $journey.start)
                TextField("Destination", text: $journey.destination)
                DatePicker("Start of Journey", selection: $journey.startDate)
                Picker("Vehicle", selection: $selectedVehicle){
                    ForEach(VehicleType.allCases){ type in
                        Text(type.displayName)
                            .tag(type)
                    }
                }
                .pickerStyle(.menu)
            }
        }
        .onChange(of: selectedVehicle){ oldValue, newValue in journey.vehicle = newValue.rawValue
        }
        .onAppear {
            if let existingType = journey.vehicleType {
                selectedVehicle = existingType
            }
        }
    }
}

#Preview {
    do {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Journey.self, configurations: config)
        var components = DateComponents()
        components.year = 2025
        components.month = 11
        components.day = 30
        let startDate = Calendar.current.date(from: components) ?? Date()
        
        let journey = Journey(
            destination: "London",
            stops: nil,
            startDate: startDate,
            vehicle: VehicleType.train.rawValue,
            infos: ["Window seat", "Bring snacks"],
            start: "Hamburg"
        )
        
        return NewJourneyView(journey: journey)
            .modelContainer(container)
    } catch {
        return Text("Failed to create container: \(error.localizedDescription)")
    }
}
