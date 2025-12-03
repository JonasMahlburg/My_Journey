// DetailView.swift
// My_Journy
//
// Created by Jonas Mahlburg on 01.12.25.
//

import SwiftUI
import MapKit
import SwiftData
import CoreLocation

// Annahme: Journey ist in einer separaten @Model Datei definiert.
// Falls nicht, muss die @Model Journey Definition hier oder in einer importierten Datei stehen.

struct DetailView: View {
    // 1. WICHTIG: @Bindable var, um die Daten ändern zu können (SwiftData/Bearbeitungsmodus)
    @Bindable var journey: Journey
    @Environment(\.modelContext) var modelContext
    
    @State private var isShowingAddInfoSheet = false
    @State private var isShowingPackingSheet = false
    
    @State private var startCoordinate: CLLocationCoordinate2D?
    @State private var destinationCoordinate: CLLocationCoordinate2D?
    @State private var camera: MapCameraPosition?
    
    private var routeCoordinates: [CLLocationCoordinate2D] {
        if let s = startCoordinate, let d = destinationCoordinate { return [s, d] }
        return []
    }
    
    private func cameraFittingRoute() -> MapCameraPosition {
        if let s = startCoordinate, let d = destinationCoordinate {
            let minLat = min(s.latitude, d.latitude)
            let maxLat = max(s.latitude, d.latitude)
            let minLon = min(s.longitude, d.longitude)
            let maxLon = max(s.longitude, d.longitude)
            let span = MKCoordinateSpan(latitudeDelta: max(0.5, (maxLat - minLat) * 1.8),
                                        longitudeDelta: max(0.5, (maxLon - minLon) * 1.8))
            let center = CLLocationCoordinate2D(latitude: (minLat + maxLat) / 2.0,
                                                longitude: (minLon + maxLon) / 2.0)
            return .region(MKCoordinateRegion(center: center, span: span))
        } else {
            // Fallback to a neutral region (e.g., Europe)
            return .region(MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 51.0, longitude: 10.0),
                span: MKCoordinateSpan(latitudeDelta: 15.0, longitudeDelta: 15.0)
            ))
        }
    }
    
    
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
            // Map-Ansicht
            Map(position: Binding(get: { camera ?? cameraFittingRoute() }, set: { newValue in camera = newValue })) {
                if let s = startCoordinate {
                    Annotation("Start", coordinate: s) {
                        ZStack {
                            Circle().fill(.blue).frame(width: 10, height: 10)
                        }
                    }
                }
                if let d = destinationCoordinate {
                    Annotation("Destination", coordinate: d) {
                        ZStack {
                            Circle().fill(.red).frame(width: 10, height: 10)
                        }
                    }
                }
                if routeCoordinates.count == 2 {
                    MapPolyline(coordinates: routeCoordinates)
                        .stroke(.blue, lineWidth: 3)
                }
            }
            .frame(width: 300, height: 200)
            .task {
                await geocodeIfNeeded()
                // Update camera after geocoding
                camera = cameraFittingRoute()
            }
            
            Section("Infos"){
                List {
                    ForEach(journey.infos ?? [], id: \.self) { info in
                        Text(info)
                    }
                    .onDelete(perform: deleteInfo) // Ermöglicht Löschen im Edit-Modus
                }
                // HACK: Setze eine minimale/dynamische Höhe für die List in der ScrollView
                .frame(minHeight: 50, idealHeight: CGFloat(journey.infos?.count ?? 0) * 44 + 50)
            }
        }
        .navigationTitle("Reise")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                HStack {
                    // Button zum Öffnen des Eingabe-Sheets
                    Button {
                        isShowingAddInfoSheet = true
                    } label: {
                        Label("Info hinzufügen", systemImage: "plus")
                    }
                }
            }
        }
        .toolbar{
            ToolbarItem(placement: .bottomBar){
                HStack{
                    Button{
                        isShowingPackingSheet = true
                    } label:{
                        Label("Packliste", systemImage: "checklist")
                    }
                }
            }
        }
        .sheet(isPresented: $isShowingAddInfoSheet) {
            AddInfoView(journey: journey)
        }
        .sheet(isPresented: $isShowingPackingSheet){
            PackingList(journey: journey)
        }
    }
    
    // MARK: - Datenbearbeitung & Geocoding
    
    func deleteInfo(offsets: IndexSet) {
        guard var currentInfos = journey.infos else { return }
        currentInfos.remove(atOffsets: offsets)
        journey.infos = currentInfos // Speichere die geänderte Liste
    }
    
    private func geocodeIfNeeded() async {
        if startCoordinate == nil {
            if let coord = await geocodeAddressString(journey.start) {
                await MainActor.run { startCoordinate = coord }
            }
        }
        if destinationCoordinate == nil {
            if let coord = await geocodeAddressString(journey.destination) {
                await MainActor.run { destinationCoordinate = coord }
            }
        }
    }
    
    private func geocodeAddressString(_ string: String) async -> CLLocationCoordinate2D? {
        await withCheckedContinuation { continuation in
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(string) { placemarks, _ in
                if let location = placemarks?.first?.location?.coordinate {
                    continuation.resume(returning: location)
                } else {
                    continuation.resume(returning: nil)
                }
            }
        }
    }
}
    
    #Preview("DetailView Sample") {
        do {
            let config = ModelConfiguration(for: Journey.self, isStoredInMemoryOnly: true)
            let container = try ModelContainer(for: Journey.self, configurations: config)
            
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
            
            return NavigationStack {
                DetailView(journey: sample)
            }
            .modelContainer(container)
        } catch {
            return Text("Fehler beim Erstellen des Containers: \(error.localizedDescription)")
        }
    }
