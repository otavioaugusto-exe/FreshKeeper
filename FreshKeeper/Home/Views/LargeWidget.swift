//
//  LargeWidget.swift
//  CasaCuida
//
//  Created by Otávio Augusto on 27/07/24.
//

import SwiftUI

struct LargeWidget: View {
	private let width: CGFloat
	private let height: CGFloat
	let geo: GeometryProxy
	let mainInfo: String
	let title: String
	let subInfo: String
	let description: String
	let mainColor: Color
	let icon: String
	
	init(geo: GeometryProxy, mainInfo: String = "1234", title: String = "Title", subInfo: String = "SubInfo", description: String = "Lorem ipsum dolor sit amet, consectetur.", mainColor: Color = .red, icon: String = "heart.fill") {
		self.geo = geo
		self.width = geo.size.width
		self.height = geo.size.height
		self.mainInfo = mainInfo
		self.title = title
		self.subInfo = subInfo
		self.description = description
		self.mainColor = mainColor
		self.icon = icon
	}
	
	var body: some View {
		ZStack{
			RoundedRectangle(cornerRadius: 12)
				.foregroundStyle(.regularMaterial)
			HStack(alignment: .center, spacing: 5) {
				Image(systemName: icon)
					.font(.system(size:geo.size.width*0.10))
					.foregroundStyle(mainColor)
					.frame(maxWidth: width*0.15)
				VStack(alignment: .leading){
					Text(subInfo)
						.font(.subheadline)
						.fontWeight(.light)
					Text(mainInfo)
						.font(.largeTitle)
						.fontWeight(.regular)
				}
				.frame(maxWidth: width*0.25)
				VStack(alignment: .leading){
					Text(title)
						.font(.title3)
						.fontWeight(.semibold)
						.foregroundStyle(.gray)
					Text(description)
						.font(.subheadline)
						.foregroundStyle(.gray)
				}
				.frame(maxWidth: width)
			}
			.frame(maxWidth: width*0.84, maxHeight: height*0.115, alignment: .leading)
		}
		.frame(maxWidth: width, maxHeight: height*0.15)
	}
}

#Preview {
	GeometryReader {geo in
		LargeWidget(geo: geo)
	}
}
