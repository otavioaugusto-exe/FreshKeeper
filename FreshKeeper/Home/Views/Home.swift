//
//  Home.swift
//  CasaCuida
//
//  Created by Otávio Augusto on 26/07/24.
//

import SwiftUI
import SwiftData

struct Home: View {
	@State private var path = NavigationPath()
    var body: some View {
		GeometryReader { geo in
			let height = geo.size.height
			let width = geo.size.width
			NavigationStack(path: $path) {
				ZStack {
					VStack() {
						LargeWidget(geo: geo)
						HStack {
							SquareWidget(geo: geo)
							SquareWidget(geo: geo)
						}
						Text("Próximos do vencimento")
							.font(.title2)
							.fontWeight(.bold)
							.frame(maxWidth: width, alignment: .leading)
					}
				}
				.navigationTitle("Seus Produtos")
				.frame(maxWidth: width*0.90, maxHeight: height*0.90)
//				.border(.red)
			}
		}
    }
}




#Preview {
    Home()
}
