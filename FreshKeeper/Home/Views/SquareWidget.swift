//
//  SquareWidget.swift
//  CasaCuida
//
//  Created by Otávio Augusto on 27/07/24.
//

import SwiftUI

struct SquareWidget: View {
	private let size: CGFloat
	let geo: GeometryProxy
	let title: String
	let mainColor: Color
	let description: String
	let icon: String
	
	init(geo: GeometryProxy, title: String = "Title", mainColor: Color = .green, description: String = "Lorem ipsum dolor sit amet, consectetur.", icon: String = "tree.fill") {
		self.geo = geo
		self.size = geo.size.width/2
		self.title = title
		self.mainColor = mainColor
		self.description = description
		self.icon = icon
		
	}
	
	var body: some View {
		ZStack{
			RoundedRectangle(cornerRadius: 12)
				.foregroundStyle(.regularMaterial)
			VStack(alignment: .leading, spacing: 15) {
				Image(systemName: icon)
					.font(.system(size:geo.size.width*0.10))
					.foregroundStyle(mainColor)
				Text(title)
					.font(.title3)
					.fontWeight(.semibold)
				Text(description)
					.font(.subheadline)
			}
			.frame(maxWidth: size*0.75, maxHeight: size*0.85, alignment: .leading)
		}
		.frame(maxWidth: size, maxHeight: size)
	}
}

#Preview {
	GeometryReader { geo in
		
		SquareWidget(geo: geo)
	}
}
