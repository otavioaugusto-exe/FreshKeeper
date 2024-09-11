import Foundation
import SwiftData
import SwiftUI

@Model
final class Product: Identifiable {
	enum ProductStatus {
		case expired, aboutToExpire, good
	}
	let id = UUID()
	var name: String
	var image: Data?
	var expirationDate: Date
	var openDate: Date
	var maxDaysOpen: Int
	var alreadyOpen: Bool = false
	var productStatus: ProductStatus {
		switch isExpired() {
		case .good:
			return isPastOpenLimit()
		case .aboutToExpire:
			return isPastOpenLimit() == .expired ? .expired : .aboutToExpire
		case .expired:
			return .expired
		}
	}
	
	init(
		name: String = "Novo Produto",
		image: Data? = nil,
		expirationDate: Date = Date(),
		openDate: Date = Date(),
		maxDaysOpen: Int = 0
	) {
		let calendar = Calendar.current
		self.name = name
		self.image = image
		self.expirationDate = calendar.startOfDay(for: expirationDate)
		self.openDate = calendar.startOfDay(for: openDate)
		self.maxDaysOpen = maxDaysOpen
	}
}

extension Product {
	// MARK: - STATUS DO PRODUTO
	/// Checa se a data de validade do produto já expirou
	/// - Returns: Retorna um valor enum do ProductStatus dependendo de sua condição.
	private func isExpired() -> ProductStatus {
		let daysUntilExpired = getDaysUntilExpired()
		if daysUntilExpired <= 0 {
			return .expired
		}
		if daysUntilExpired <= 3 {
			return .aboutToExpire
		}
		return .good
	}
	
	/// Checa se o produto está expirado de acordo com o tempo máximo de abertura.
	/// - Returns: Retorna um valor enum do ProductStatus dependendo de sua condição.
	private func isPastOpenLimit() -> ProductStatus {
		guard alreadyOpen else {
			return .good
		}
		let daysOpen = getDaysAlreadyOpen()
		if daysOpen >= maxDaysOpen {
			return .expired
		}
		if daysOpen >= maxDaysOpen - 1 {
			return .aboutToExpire
		}
		return .good
	}
}

// MARK: - CALCULOS DE DATAS
extension Product {
	
	/// Calcula quantos dias de diferença possui entre duas datas.
	/// - Parameters:
	///   - date: Data inicial
	///   - targetDate: Data Final
	/// - Returns: Quantidade de dias entre as datas em número inteiro.
	private func calculateDays(from date: Date, to targetDate: Date) -> Int {
		let calendar = Calendar.current
		print(self.name, Int((calendar.startOfDay(for: targetDate).timeIntervalSince(date))/86400))
		return Int((calendar.startOfDay(for: targetDate).timeIntervalSince(calendar.startOfDay(for: date)))/86400)
	}
	
	/// Checa a quantos dias o produto já está aberto desde a data informada pelo usuário em openDate.
	/// - Returns: Retorna um Int com a quantidade de dias em que o produto está aberto até o momento.
	func getDaysAlreadyOpen() -> Int {
		calculateDays(from: openDate, to: Date())
	}
	
	/// Checa quando dias falta para expirar a data de validade do produto.
	/// - Returns: Retorna um Int com os dias restantes.
	func getDaysUntilExpired() -> Int {
		calculateDays(from: Date(), to: expirationDate )
	}
	
	/// Checa quantos dias (em segundos) o produto pode continuar aberto depois de sua abertura.
	/// - Returns: Retorna um intervalo de tempo em segundos restantes até o produto expirar.
	func getOpenTimeRemaining() -> TimeInterval {
		let calendar = Calendar.current
		let maxTimeOpen = TimeInterval(maxDaysOpen*86400)
		let maxOpenDate = calendar.startOfDay(for: openDate).addingTimeInterval(maxTimeOpen)
		return maxOpenDate.timeIntervalSinceNow
	}
	
	/// Checa quando dias (em segundos) falta para expirar a data de validade do produto.
	/// - Returns: Retorna um intervalo de tempo em segundos restantes até o vencimemento.
	func getTimeUntilExpired() -> TimeInterval {
		let calendar = Calendar.current
		return calendar.startOfDay(for: expirationDate).timeIntervalSinceNow
	}
}

// MARK: - MANIPULAÇÃO DE IMAGEM
extension Product {
	/// Realiza a conversão e unwrap da imagem de Data? para UIImage.
	/// - Returns: Retorna a foto do produto em uma UIImage para uso posterior.
	func unwrapProductImage() -> UIImage {
		guard let imageData = image,
			  let uiImage = UIImage(data: imageData)
		else { return UIImage(named: "productDefault")! }
		return uiImage
	}
}
