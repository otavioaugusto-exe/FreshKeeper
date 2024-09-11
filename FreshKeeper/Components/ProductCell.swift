//
//  ProductCell.swift
//  FreshKeeper
//
//  Created by Otávio Augusto on 8/9/24.
//

import Foundation
import SwiftUI

/// Cria as Cells para o produto
struct ProductCell: View {
	let product: Product
	
	init(for product: Product) {
		self.product = product
	}
	
	var body: some View {
		HStack {
			Image(uiImage: product.unwrapProductImage())
			   .resizable()
			   .scaledToFill()
			   .frame(maxWidth: 60)
			   .clipShape(.circle)
			   .padding(.trailing, 20)
			ProductLabelMaker.getProductLabel(for: product)
		   .frame(maxWidth: 200, alignment: .leading)
	   }
	   .frame(height: 70)
	}
}
