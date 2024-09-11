//
//  Home.swift
//  FreshKeeper
//
//  Created by Otávio Augusto on 26/07/24.
//

import SwiftUI
import SwiftData

struct HomeView: View {
	@Environment(\.modelContext) private var modelContext
	@State private var editedProduct: Product?
	@Query private var products: [Product]

	var body: some View {
		let expiredProducts = products.filter{$0.productStatus == .expired}
		let aboutToExpireProducts = products.filter{$0.productStatus == .aboutToExpire}
		GeometryReader { geo in
			let height = geo.size.height
			let width = geo.size.width
			NavigationStack {
				ZStack(alignment: .top) {
					LinearGradient(gradient: Gradient(colors: [Color.indigo.opacity(0.8), Color.clear]), startPoint: .top, endPoint: .bottom)
						.frame(height: 200)
						.edgesIgnoringSafeArea(.all)
					VStack() {
						// QUANDO HOUVER PRODUTOS EXPIRADOS
						if !(expiredProducts.isEmpty) {
							LargeWidget(
								geo: geo,
								mainInfo: "\(expiredProducts.count)",
								title: "Itens vencidos",
								subInfo: "Produtos",
								description: "Você possui itens para descarte",
								mainColor: .red,
								icon: "exclamationmark.triangle.fill"
							)
							.padding(.top, height*0.05)
						// QUANDO OS PRODUTOS ESTIVER OK
						} else {
							LargeWidget(
								geo: geo,
								title: "Tudo OK!",
								subInfo: "Produtos",
								description: "Todos produtos estão dentro do prazo de validade",
								mainColor: .green,
								icon: "sparkles"
							)
							.padding(.top, height*0.05)
						}
						// WIDGETS PEQUENOS / SEM FUNÇÃO NO MOMENTO
						HStack {
							SquareWidget(
								geo: geo,
								title: "Verifique a validade na compra!",
								mainColor: .yellow,
								description: "",
								icon: "cart.fill.badge.questionmark")
							SquareWidget(
								geo: geo,
								title: "Separe as embalagens recicláveis",
								mainColor: .green,
								description: "",
								icon: "arrow.3.trianglepath")
						}
						
						Text("Próximos a expirar")
							.font(.title2)
							.fontWeight(.bold)
							.frame(maxWidth: width, alignment: .leading)
							.padding(.top, height*0.05)
						// QUANDO OS PRODUTOS ESTIVER OK
						if aboutToExpireProducts.isEmpty {
							VStack {
								Image(systemName: "party.popper.fill")
									.resizable()
									.foregroundStyle(.quaternary)
									.frame(maxWidth: width*0.15, maxHeight: height*0.075)
								Text("Nada a se preocupar!")
									.foregroundStyle(.tertiary)
									.padding(.top, height*0.02)
							}
							.frame(maxHeight: .infinity)
						// QUANDO HOUVER PRODUTOS EXPIRADOS
						} else {
							VStack(alignment: .leading) {
								List {
									ForEach(aboutToExpireProducts) { product in
										Button {
											editedProduct = product
										} label: {
											ProductCell(for: product)
										}
									}
									.listRowInsets(EdgeInsets(top: 15, leading: 0, bottom: 15, trailing: 0))
								}
								.listStyle(PlainListStyle())
								.scrollContentBackground(.hidden)
							}
						}
					}
					.frame(maxWidth: width*0.90, maxHeight: height*0.90)
				}
				.navigationTitle("Seus Produtos")
			}
//			.onAppear {
//				ProductSample.generateSampleProducts().forEach{modelContext.insert($0)}
//			}
			.sheet(item: $editedProduct) { product in
				EditProductView(product: product)
			}
		}
	}
}

#Preview {
	let config = ModelConfiguration(isStoredInMemoryOnly: true)
	let container = try! ModelContainer(for: Product.self, configurations:  config)
	HomeView()
		.modelContainer(container)
}
