//
//  Shelf.swift
//  CasaCuida
//
//  Created by Otávio Augusto on 26/07/24.
//

import SwiftUI
import SwiftData

struct Shelf: View {
	@Environment(\.modelContext) var modelContext
	@State var path = NavigationPath()
	@Query var products: [Product]
	
	
    var body: some View {
		NavigationStack(path: $path) {
			VStack(alignment: .leading) {
				List {
					ForEach(products) { product in
						NavigationLink(value: product) {
							HStack {
								unwrapProductImage(for: product)
									.resizable()
									.scaledToFit()
									.frame(maxWidth: 60)
									.clipShape(.circle)
									.padding(.trailing, 20)
								
								VStack(alignment: .leading) {
									Text(product.name)
										.font(.title2)
										.fontWeight(.semibold)
										.lineLimit(1)
										.padding(.bottom, 3)
									
									Text(product.expirationDate.formatted(date: .numeric, time: .omitted))
										.font(.subheadline)
										.foregroundStyle(.secondary)
										.lineLimit(1)
									
								}
								.frame(maxWidth: 200, alignment: .leading)
							}
							.frame(height: 70)
							.swipeActions(edge: .leading){
								Button() {
									path.append(product)
								} label: {
									Label("Editar", systemImage: "square.and.pencil")
								}
							}
							.swipeActions(edge: .trailing){
								Button {
									modelContext.delete(product)
								} label: {
									Label("Deletar", systemImage: "trash.fill")
								}
								.tint(.red)
							}
						}
					}
				}
			}
			.toolbar {
				ToolbarItem{
					Button("Gerar samples", action: makeProductSample)
						.foregroundStyle(.green)
				}
				ToolbarItem{
					Button(action: makeProductSample) {
						Text("Novo produto +")
							.fontWeight(.semibold)
					}
				}
			}
			.navigationDestination(for: Product.self) { product in
				Text(product.name)
			}
			.navigationTitle("Prateleira")
		}
		.tint(.indigo)
    }
	
	func unwrapProductImage(for product: Product) -> Image {
		guard let imageData = product.Image,
			  let uiImage = UIImage(data: imageData)
		else { return Image("productDefault")}
		return Image(uiImage: uiImage)
	}
	
	func makeProductSample() -> Void {
		let example1 = Product(name: "Leite", Image: nil, expirationDate: Date.now, openDate: Date.now, maxDaysOpen: 4)
		let example2 = Product(name: "Trigo", Image: nil, expirationDate: Date.now, openDate: Date.now, maxDaysOpen: 4)
		let example3 = Product(name: "Achocolatado", Image: nil, expirationDate: Date.now, openDate: Date.now, maxDaysOpen: 4)
		modelContext.insert(example1)
		modelContext.insert(example2)
		modelContext.insert(example3)
	}
	
}

#Preview {
	let config = ModelConfiguration(isStoredInMemoryOnly: true)
	let container = try! ModelContainer(for: Product.self, configurations:  config)
    Shelf()
		.modelContainer(container)
}
