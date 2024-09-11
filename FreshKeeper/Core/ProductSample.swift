//
//  ProductSample.swift
//  FreshKeeper
//
//  Created by Otávio Augusto on 7/9/24.
//
import Foundation
import UIKit

struct ProductSample {
	
	static func generateSampleProducts() -> [Product] {
		var sampleProducts = [Product]()
		
		// Array com diferentes nomes de produtos
		let names: [String] = [
			"Leite Integral",
			"Queijo Prato",
			"Iogurte Natural",
			"Maçã Verde",
			"Banana",
			"Ovo Caipira",
			"Manteiga",
			"Pão de Forma",
			"Cereal Matinal",
			"Suco de Laranja",
			"Tomate",
			"Arroz Integral",
			"Feijão Preto",
			"Macarrão",
			"Salame"
		]
				
		let expirationDates: [Date] = [
			Date().addingTimeInterval(86400 * 10), // 10 dias no futuro
			Date().addingTimeInterval(86400 * 20), // 20 dias no futuro
			Date().addingTimeInterval(86400 * 30), // 30 dias no futuro
			Date().addingTimeInterval(86400 * 40), // 40 dias no futuro
			Date().addingTimeInterval(86400 * 50), // 50 dias no futuro
			Date().addingTimeInterval(86400 * 60), // 60 dias no futuro
			Date().addingTimeInterval(86400 * 70), // 70 dias no futuro
			Date().addingTimeInterval(86400 * 80), // 80 dias no futuro
			Date().addingTimeInterval(86400 * 90), // 90 dias no futuro
			Date().addingTimeInterval(86400 * 100), // 100 dias no futuro
			Date().addingTimeInterval(-86400 * 10), // 10 dias no passado
			Date().addingTimeInterval(-86400 * 20), // 20 dias no passado
			Date().addingTimeInterval(-86400 * 30), // 30 dias no passado
			Date().addingTimeInterval(-86400 * 40), // 40 dias no passado
			Date().addingTimeInterval(-86400 * 50) // 50 dias no passado
		]
		
		let openDates: [Date] = [
			Date(), // Data atual
			Date().addingTimeInterval(-86400 * 1), // 1 dia no passado
			Date().addingTimeInterval(-86400 * 2), // 2 dias no passado
			Date().addingTimeInterval(-86400 * 3), // 3 dias no passado
			Date().addingTimeInterval(-86400 * 4), // 4 dias no passado
			Date().addingTimeInterval(-86400 * 5), // 5 dias no passado
			Date().addingTimeInterval(-86400 * 6), // 6 dias no passado
			Date().addingTimeInterval(-86400 * 7), // 7 dias no passado
			Date().addingTimeInterval(-86400 * 8), // 8 dias no passado
			Date().addingTimeInterval(-86400 * 9), // 9 dias no passado
			Date().addingTimeInterval(-86400 * 10), // 10 dias no passado
			Date().addingTimeInterval(-86400 * 11), // 11 dias no passado
			Date().addingTimeInterval(-86400 * 12), // 12 dias no passado
			Date().addingTimeInterval(-86400 * 13), // 13 dias no passado
			Date().addingTimeInterval(-86400 * 14) // 14 dias no passado
		]
		
		let maxDaysOpens: [Int] = [
			2,  // 1 dia
			3,  // 2 dias
			3,  // 3 dias
			4,  // 4 dias
			5,  // 5 dias
			6,  // 6 dias
			7,  // 7 dias
			8,  // 8 dias
			9,  // 9 dias
			10, // 10 dias
			11, // 11 dias
			12, // 12 dias
			13, // 13 dias
			14, // 14 dias
			15  // 15 dias
		]
		(0..<names.count).forEach{
			let product = Product(name: names[$0], image: nil, expirationDate: expirationDates[$0], openDate: openDates[$0], maxDaysOpen: maxDaysOpens[$0]);
			product.alreadyOpen = .random()
			sampleProducts.append(product)}
		return sampleProducts
	}
}
											

