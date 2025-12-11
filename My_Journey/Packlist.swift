//
//  Packlist.swift
//  My_Journy
//
//  Created by Jonas Mahlburg on 11.12.25.
//

import Foundation
import SwiftData

@Model
final class PackItem: Identifiable {
    var id: UUID
    var name: String
    var isPacked: Bool

    init(name: String, isPacked: Bool = false) {
        self.id = UUID()
        self.name = name
        self.isPacked = isPacked
    }
}
