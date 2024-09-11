//
//  FreshKeeperApp.swift
//  FreshKeeper
//
//  Created by Otávio Augusto on 31/07/24.
//

import SwiftUI
import SwiftData

@main
struct FreshKeeperApp: App {
    var body: some Scene {
        WindowGroup {
			MainView()
        }
		.modelContainer(for: Product.self)
    }
}
