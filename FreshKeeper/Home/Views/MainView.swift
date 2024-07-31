//
//  MainView.swift
//  CasaCuida
//
//  Created by Otávio Augusto on 25/07/24.
//

import SwiftUI

struct MainView: View {
	enum tabs {
	case home, shelf
	}
	
    var body: some View {
		TabView {
			Tab("Início", systemImage: "house.fill"){
				Home()
			}
			Tab("Prateleira", systemImage: "shippingbox.fill"){
				Shelf()
			}
		}
		.tint(.indigo)
    }
}

#Preview {
	MainView()
}
