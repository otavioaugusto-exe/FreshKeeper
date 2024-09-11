//
//  ProductLabelMaker.swift
//  FreshKeeper
//
//  Created by Otávio Augusto on 10/9/24.
//

import Foundation
import SwiftUI

struct ProductLabelMaker {
	
	/// Cria as labels para os produtos de acordo com a estilização e paramêtros definidos.
	/// - Parameters:
	///   - product: Produto que irá ter as labels criadas.
	///   - mainColor: Cor do titulo.
	///   - title: Titulo da cell.
	///   - subtitle: Subtitulo da cell.
	/// - Returns: Retorna uma cell com 3 linhas de informação pronta para uso.
	private static func makeProductLabel(
		for product: Product,
		mainColor: Color,
		title: String,
		subtitle: String) -> some View {
			VStack(alignment: .leading
			) {
				Text(title)
					.font(.title2)
					.foregroundStyle(mainColor)
					.fontWeight(.semibold)
					.lineLimit(1)
					.padding(.bottom, 2)
				
				Text(subtitle)
					.foregroundStyle(Color.secondary)
					.font(.subheadline)
					.foregroundStyle(.secondary)
					.lineLimit(1)
				
				if !product.alreadyOpen {
					Text("Não aberto")
						.foregroundStyle(Color.secondary)
						.font(.subheadline)
						.foregroundStyle(.secondary)
						.lineLimit(1)
				} else {
					Text(product.getDaysAlreadyOpen() < 1 ? "Aberto hoje" : "Aberto há \(product.getDaysAlreadyOpen()) dia(s)" )
						.foregroundStyle(Color.secondary)
						.font(.subheadline)
						.foregroundStyle(.secondary)
						.lineLimit(1)
				}
			}
		}
	
	/// Pede a criação das labels de acordo com o status do produto.
	/// - Parameter product: Produto a ser avaliado para criação das labels.
	/// - Returns: Retorna as devidas labels de acordo com o estado do produto,
	static func getProductLabel(for product: Product) -> some View {
		let productStatus = product.checkProduct()
		
		return Group {
			switch productStatus {
			case .aboutToExpire:
				makeProductLabel(
					for: product,
					mainColor: .yellow,
					title: product.name,
					subtitle: product.getDaysUntilExpired() > 1 ? "Expira em \(product.getDaysUntilExpired()) dia(s)" : "Expira amanhã"
				)
			case .expired:
				makeProductLabel(
					for: product,
					mainColor: .red,
					title: product.name,
					subtitle: "Descarte, prazo expirado."
				)
			default:
				makeProductLabel(
					for: product,
					mainColor: Color(uiColor: UIColor.label),
					title: product.name,
					subtitle: product.getDaysUntilExpired() > 1 ? "Expira em \(product.getDaysUntilExpired()) dia(s)" : "Expira amanhã"
				)
			}
		}
	}
}
