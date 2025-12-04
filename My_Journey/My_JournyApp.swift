//
//  My_JournyApp.swift
//  My_Journy
//
//  Created by Jonas Mahlburg on 01.12.25.
//

import SwiftUI
import SwiftData

@main
struct My_JournyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Journey.self)
    }
}
