//
//  EditProductView.swift
//  FreshKeeper
//
//  Created by Otávio Augusto on 01/08/24.
//

import SwiftUI
import SwiftData

struct EditProductView: View {
	@Environment(\.dismiss) private var dismiss
	@Environment(\.modelContext) private var modelContext
	@Bindable var product: Product
	@State var isEditing: Bool = false
	
	var body: some View {
		GeometryReader { geometry in
			let height = geometry.size.height
			let todaysDate = Calendar.current.startOfDay(for: Date.now)
			NavigationStack {
				ZStack {
					Color
						.indigo.opacity(0.15)
						.ignoresSafeArea()
					VStack {
						RoundPHPicker(avatarData: $product.image, size: height * 0.35)
						Form {
							Section("Produto") {
								TextField("Nome do produto", text: $product.name)
									.disabled(!isEditing)
							}
							
							Section("Validade para consumo") {
								DatePicker("Data de validade", selection: $product.expirationDate, displayedComponents: .date)
									.padding(.vertical, 5)
									.disabled(!isEditing)
								Picker("eita", selection: $product.alreadyOpen) {
									Text("Aberto")
										.tag(true)
									Text("Fechado")
										.tag(false)
								}
								.padding(.vertical, 5)
								.pickerStyle(.segmented)
								.disabled(!isEditing)
								
								if product.alreadyOpen {
									DatePicker("Data de abertura", selection: $product.openDate, in: ...todaysDate, displayedComponents: .date)
										.padding(.vertical, 5).disabled(!isEditing)
								}
								
								// QUANDO NÃO ESTIVER EDITANDO
								if !isEditing {
									switch product.productStatus {
									case .expired:
										Text("Descarte, prazo expirado.")
											.foregroundStyle(.red)
									default:
										Text("Consumir em até \(product.maxDaysOpen) dias")
											.padding(.vertical)
									}
								// QUANDO EDITAR
								} else {
									Stepper("Consumir em até \(product.maxDaysOpen) dias", value: $product.maxDaysOpen, in: 0...31)
										.padding(.vertical, 6)
								}
							}
						}
						// AGENDA NOTIFICAÇÃO AO DISMISS DA SHEET
						.onDisappear{
							NotificationService.notificationScheduler(for: product)
							isEditing = false
						}
						.scrollContentBackground(.hidden)
					}
				}
				.toolbar{
					// QUANDO NÃO ESTIVER EDITANDO
					if !isEditing {
						ToolbarItem(placement: .topBarTrailing) {
							Button{
								isEditing.toggle()
							} label: {
								Text("Editar")
									.foregroundStyle(.indigo)
									.fontWeight(.semibold)
							}
						}
					// QUANDO EDITAR
					} else {
						ToolbarItem(placement: .topBarTrailing) {
							Button{
								isEditing.toggle()
							} label: {
								Text("OK")
									.foregroundStyle(.indigo)
									.fontWeight(.semibold)
							}
						}
					}
					// NAME ESTÁ PREENCHDIO E NÃO ESTÁ EDITANDO
					if !product.name.isEmpty && !isEditing {
						ToolbarItem(placement: .topBarLeading) {
							Button{
								dismiss()
							} label: {
								Text("Salvar")
									.foregroundStyle(.indigo)
									.fontWeight(.semibold)
							}
						}
					}
					
				}
			}
			.interactiveDismissDisabled(isEditing)
		}
	}
}

#Preview {
	let example = Product(name: "Leite", image: nil, expirationDate: Date.now, openDate: Date.now, maxDaysOpen: 4)
	EditProductView(product: example)
}
