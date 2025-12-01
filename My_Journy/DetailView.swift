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
    private let initialCamera: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275),
            span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
        )
    )

    var body: some View {
        
        
        Map(initialPosition: initialCamera) {
            // Add map content here if needed, e.g., UserAnnotation(), Marker, etc.
        }
        .frame(width: 300, height: 200)
    }
}

#Preview {
    DetailView()
}
