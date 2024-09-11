//
//  Shelf.swift
//  FreshKeeper
//
//  Created by Otávio Augusto on 26/07/24.
//

import SwiftUI
import SwiftData

struct ShelfView: View {
	@Environment(\.modelContext) private var modelContext
	@State private var editedProduct: Product?
	@State private var newProduct: Product?
	@Query private var products: [Product]
	
	var body: some View {
		GeometryReader { geo in
			let width = geo.size.width
			let height = geo.size.height
			NavigationStack {
				VStack(alignment: .leading) {
					// QUANDO NÃO HOUVER PRODUTOS CADASTRADOS
					if products.isEmpty {
						VStack {
							Image(systemName: "lizard.fill")
								.resizable()
								.foregroundStyle(.quaternary)
								.frame(maxWidth: width*0.25, maxHeight: height*0.125)
							Text("Cadastre um produto para acompanhar seu status!")
								.foregroundStyle(.tertiary)
								.multilineTextAlignment(.center)
								.frame(maxWidth: width*0.60)
								.padding(.top, height*0.02)
						}
						.frame(maxHeight: .infinity)
					// QUANDO HÁ PRODUTOS CADASTRADOS
					} else {
						List {
							ForEach(products) { product in
								Button {
									editedProduct = product
								} label: {
									ProductCell(for: product)
								}
							}
							.onDelete(perform: deleteProduct)
						}
					}
				}
				.padding(.top, height*0.05)
				.navigationTitle("Prateleira")
				// NOVO PRODUTO ENTRA EM MODO EDIÇÃO
				.sheet(item: $newProduct) {
					EditProductView(product: $0 , isEditing: true)
				}
				// PRODUTO EXISTENTE ENTRA EM MODO VISUALIZAÇÃO
				.sheet(item: $editedProduct) {
					EditProductView(product: $0)
				}
				.toolbar {
					ToolbarItem{
						Button(action: makeBlankProduct) {
							Text("Novo produto +")
								.fontWeight(.semibold)
						}
					}
				}
			}
			.tint(.indigo)
		}
	}
	
	func deleteProduct(_ indexSet: IndexSet) -> Void {
		for index in indexSet {
			let product = products[index]
			modelContext.delete(product)
		}
	}
	func makeBlankProduct() -> Void {
		newProduct = Product()
		if let newProduct {
			modelContext.insert(newProduct)
		}
	}
	
}

#Preview {
	let config = ModelConfiguration(isStoredInMemoryOnly: true)
	let container = try! ModelContainer(for: Product.self, configurations:  config)
    ShelfView()
		.modelContainer(container)
}
