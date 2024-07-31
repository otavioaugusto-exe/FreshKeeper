import Foundation
import SwiftData

@Model
final class Product: Identifiable {
	let id = UUID()
	let name: String
	let Image: Data?
	let expirationDate: Date
	let openDate: Date
	let maxDaysOpen: Int
	let daysToWarning: Int
	
	init(name: String, Image: Data?, expirationDate: Date, openDate: Date, maxDaysOpen: Int, daysToWarning: Int) {
		self.name = name
		self.Image = Image
		self.expirationDate = expirationDate
		self.openDate = openDate
		self.maxDaysOpen = maxDaysOpen
		self.daysToWarning = daysToWarning
	}
}
