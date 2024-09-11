import Foundation
import SwiftData
import SwiftUI

@Model
final class Product: Identifiable {
	let id = UUID()
	var name: String
	var image: Data?
	var expirationDate: Date
	var openDate: Date
	var maxDaysOpen: Int
	var alreadyOpen: Bool = false
	
	enum ProductStatus {
		case expired, aboutToExpire, good
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
	
	/// Checa a quantos dias o produto já está aberto desde a data informada pelo usuário em openDate.
	/// - Returns: Retorna um Int com a quantidade de dias em que o produto está aberto até o momento.
	func getDaysAlreadyOpen() -> Int {
		let calendar = Calendar.current
		return Int((calendar.startOfDay(for: Date()).timeIntervalSince(openDate))/86400)
	}
	
	/// Checa quantos dias o produto pode continuar aberto depois de sua abertura.
	/// - Returns: Retorna um intervalo de tempo em segundos restantes até o produto expirar.
	func getremainingTimeUntilExpiration() -> TimeInterval {
		let calendar = Calendar.current
		let maxTimeOpen = TimeInterval(maxDaysOpen*86400)
		let maxOpenDate = calendar.startOfDay(for: openDate).addingTimeInterval(maxTimeOpen)
		return maxOpenDate.timeIntervalSinceNow
	}
	
	/// Checa quando dias falta para expirar a data de validade do produto.
	/// - Returns: Retorna um Int com os dias restantes.
	func getDaysUntilExpired() -> Int {
		let calendar = Calendar.current
		return Int(calendar.startOfDay(for: expirationDate).timeIntervalSince(calendar.startOfDay(for: Date())) / 86400)
	}
	
	/// Checa quando dias falta para expirar a data de validade do produto.
	/// - Returns: Retorna um intervalo de tempo em segundos restantes até o vencimemento.
	func getTimeUntilExpired() -> TimeInterval {
		let calendar = Calendar.current
		return calendar.startOfDay(for: expirationDate).timeIntervalSinceNow
	}
	
	/// Checa o estado de conservação do produto
	/// - Returns: Retorna um valor enum do ProductStatus dependendo de sua condição.
	func checkProduct() -> ProductStatus {
		let expiredStatus = isExpired()
		let openStatus = isPastOpenLimit()
		switch expiredStatus {
		case .good:
			return openStatus
		case .expired:
			return expiredStatus
		case .aboutToExpire:
			if openStatus == .expired {
				return openStatus
			} else {
				return expiredStatus
			}
		}
	}
	
	/// Realiza a conversão e unwrap da imagem de Data? para UIImage.
	/// - Returns: Retorna a foto do produto em uma UIImage para uso posterior.
	func unwrapProductImage() -> UIImage {
		guard let imageData = image,
			  let uiImage = UIImage(data: imageData)
		else { return UIImage(named: "productDefault")! }
		return uiImage
	}
}
 
