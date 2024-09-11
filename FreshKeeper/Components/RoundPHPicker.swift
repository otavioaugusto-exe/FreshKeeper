//
//  RoundPHPicker.swift
//  FoodFlow
//
//  Created by Otávio Augusto on 05/07/24.
//

import SwiftUI
import PhotosUI

/// Photo picker em formato redondo, retorna a imagem para uso em Data?
struct RoundPHPicker: View {
	@State private var avatarItem: PhotosPickerItem?
	@State private var avatarImage: Image?
	@Binding var avatarData: Data?
	let mainColor: Color
	let defaultImage: Image
	let icon: String
	let size: CGFloat
	
	init(
		avatarItem: PhotosPickerItem? = nil,
		avatarImage: Image? = nil,
		avatarData: Binding<Data?>,
		mainColor: Color = .indigo,
		defaultImage: Image = Image("productDefault"),
		icon: String = "person.crop.square.badge.camera.fill",
		size: CGFloat = 230
	) {
		self.avatarItem = avatarItem
		self.avatarImage = avatarImage
		self._avatarData = avatarData
		self.mainColor = mainColor
		self.defaultImage = defaultImage
		self.icon = icon
		self.size = size
	}
	
	var body: some View {
		ZStack {
			loadImage()
					.resizable(resizingMode: .stretch)
					.aspectRatio(contentMode: .fill)
					.clipShape(.circle)

			Circle()
				.stroke(mainColor, lineWidth: 2)
			if size * 3 > 500, avatarImage == nil {
				editButton()
			}
			PhotosPicker(selection: $avatarItem, matching: .any(of: [.images, .not(.videos)])) {
				Circle()
					.foregroundStyle(.clear)
			}
			if size * 3 > 500, avatarImage != nil {
				deleteButton()
			}
			
		}
		.frame(minWidth: size, maxWidth: size, minHeight: size ,maxHeight: size)
		.onChange(of: avatarItem) {
			Task {
				if let loaded = try? await avatarItem?.loadTransferable(type: Data.self) {
						avatarData = loaded
						if let uiImage = UIImage(data: loaded) {
							avatarImage = Image(uiImage: uiImage)
						}
				} else {
					print("failed")
				}
			}
		}
		
	}
	
	func deleteButton() -> some View {
			Circle()
				.overlay {
					Button {
						avatarImage = nil
						avatarItem = nil
						avatarData = nil
					} label: {
						Image(systemName: "trash.fill")
							.font(.system(size: size*0.09, weight: .bold))
					}
					.frame(maxWidth: size*0.2, maxHeight: size*0.2)
					.foregroundColor(.white)
					.background(Color(mainColor))
					.clipShape(.circle)
				}
				.background(.background)
				.clipShape(.circle)
				.foregroundStyle(.indigo.opacity(0.15))
				.frame(width: size*0.25, height: size*0.25)
				.offset(x:size*0.24, y: size*0.42)
	}
	
	func editButton() -> some View {
		Circle()
			.overlay {
				Image(systemName: "pencil")
				.font(.system(size: size*0.09, weight: .bold))
				.frame(maxWidth: size*0.2, maxHeight: size*0.2)
				.foregroundColor(.white)
				.background(Color(mainColor))
				.clipShape(.circle)
			}
			.background(.background)
			.clipShape(.circle)
			.foregroundStyle(.indigo.opacity(0.15))
			.frame(width: size*0.25, height: size*0.25)
			.offset(x:size*0.24, y: size*0.42)
	}
	
	func loadImage() -> Image {
		if let avatarData, let loadedImage = UIImage(data: avatarData) {
			return Image(uiImage: loadedImage)
		} else {
			return defaultImage
		}
	}
}

#Preview {
	@Previewable @State var avatarImage: Data?
	ZStack{
		Color(.indigo.opacity(0.20))
			.ignoresSafeArea()
		RoundPHPicker(avatarData: $avatarImage)
			.border(.red)
	}
}

