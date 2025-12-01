//
//  DetailView.swift
//  My_Journy
//
//  Created by Jonas Mahlburg on 01.12.25.
//

import SwiftUI
import MapKit
import SwiftData

struct DetailView: View {
    let journey: Journey
    @Environment(\.modelContext) var modelContext
    
    private let initialCamera: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275),
            span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
        )
    )
    
    private var vehicleSymbolName: String {
        switch journey.vehicle.lowercased() {
        case "plane", "flugzeug":
            return "airplane.up.right"
        case "car", "auto":
            return "car"
        case "train", "zug":
            return "train.side.front.car"
        case "ship", "boat", "schiff", "boot":
            return "ferry"
        case "bicycle", "bike", "fahrrad":
            return "bicycle"
        case "bus":
            return "bus"
        case "tram":
            return "tram"
        case "walk", "zu fuß", "laufen":
            return "figure.walk"
        default:
            return "questionmark.circle"
        }
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 8) {
                Text("\(journey.start) to \(journey.destination)")
                    .font(.headline)
                Image(systemName: vehicleSymbolName)
                    .symbolRenderingMode(.hierarchical)
                Text(journey.startDate, style: .date)
            }
            Map(initialPosition: initialCamera) {
                // Add map content here if needed, e.g., UserAnnotation(), Marker, etc.
            }
            .frame(width: 300, height: 200)

        }
        .navigationTitle("Reise")
            .font(.title)
        Section("Infos"){
            List {
                ForEach(journey.infos ?? [], id: \.self) { info in
                    Text(info)
                }
            }
        }
    }
}

#Preview {
    // TODO: Replace with a real Journey from your model context as needed
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
    DetailView(journey: sample)
}
