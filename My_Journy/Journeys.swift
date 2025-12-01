//
//  Journeys.swift
//  My_Journy
//
//  Created by Jonas Mahlburg on 01.12.25.
//

import Foundation
import SwiftData

@Model
class Journey{
    var destination: String
    var start: String
    var stops = [String]()
    var startDate: Date
    var vehicle: String
    var infos = [String]()
    
    init(destination: String, stops: [String] = [String](), startDate: Date, vehicle: String, infos: [String] = [String](), start: String) {
        self.destination = destination
        self.stops = stops
        self.startDate = startDate
        self.vehicle = vehicle
        self.infos = infos
        self.start = start
    }
}
