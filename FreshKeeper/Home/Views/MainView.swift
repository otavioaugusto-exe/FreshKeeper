//
//  MainView.swift
//  FreshKeeper
//
//  Created by Otávio Augusto on 25/07/24.
//

import SwiftUI
import SwiftData

struct MainView: View {
	
	enum tabs {
		case home, shelf
	}
	
	var body: some View {
		TabView {
			Tab("Início", systemImage: "house.fill"){
				HomeView()
			}
			Tab("Prateleira", systemImage: "shippingbox.fill"){
				ShelfView()
			}
		}
		.tint(.indigo)
	}
}

#Preview {
	let config = ModelConfiguration(isStoredInMemoryOnly: true)
	let container = try! ModelContainer(for: Product.self, configurations:  config)
	MainView()
		.modelContainer(container)
}
