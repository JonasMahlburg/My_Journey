//
//  Journeys.swift
//  My_Journy
//
//  Created by Jonas Mahlburg on 01.12.25.
//

import Foundation
import SwiftData

enum VehicleType: String, Identifiable, CaseIterable {
    case car = "Auto"
    case train = "Zug"
    case plane = "Flugzeug"
    case ship = "Schiff"
    case bicycle = "Fahrrad"
    case walk = "Zu Fuß"
    
    var id: String { self.rawValue }
    
    var displayName: String {
        self.rawValue
    }
}

@Model
class Journey {
    var destination: String
    var stops: [String]?
    var start: String
    var startDate: Date
    var vehicle: String
    var infos: [String]?
    
    init(destination: String, stops: [String]? = nil, startDate: Date, vehicle: String, infos: [String]? = nil, start: String) {
        self.destination = destination
        self.stops = stops
        self.startDate = startDate
        self.vehicle = vehicle
        self.infos = infos
        self.start = start
    }
    var vehicleType: VehicleType? {
        VehicleType(rawValue: vehicle)
    }
}
