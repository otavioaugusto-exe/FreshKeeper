//
//  NotificationService.swift
//  FreshKeeper
//
//  Created by Otávio Augusto on 10/9/24.
//

import Foundation
import UserNotifications

struct NotificationService {
	
	/// Pede autorização para envio de notificações ao usuário.
	private static func requestNotificationAuth() {
		UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { success, error in
			if success {
				print("AUTH NOTIFICAÇÃO ACEITA")
			} else if let error {
				print(error.localizedDescription)
			}
		}
	}
	
	/// Cria a notificação para vencimento dos produtos de acordo com um com um intervalo de tempo e booleano.
	/// - Parameters:
	///   - title: Título da notificação
	///   - description: Descrição da notificação
	///   - timeInterval: Tempo em segundos até a notificação ser recebida
	///   - identifier: ID único para a notificação
	///   - shouldSendNotification: Closure que retorna um booleano confirmando a criação ou não da notificação.
	private static func makePushNotification(
		title: String,
		description: String,
		timeInterval: TimeInterval,
		identifier: String,
		shouldSendNotification: () -> Bool
	) {
		switch shouldSendNotification() {
		case true:
			let content = UNMutableNotificationContent()
			content.title = title
			content.body = description
			content.sound = UNNotificationSound.default
			let trigger = UNTimeIntervalNotificationTrigger(timeInterval: timeInterval, repeats: false)
			let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
			UNUserNotificationCenter.current().add(request) { error in
				if let error {
					print("erro ao adicionar notificação \(error.localizedDescription)")
				}
			}
		case false:
			cancelPushNotification(for: identifier)
		}
	}
	
	/// Cancela a notificação do respectivo identifier
	/// - Parameter identifier: String com o ID único da notificação.
	private static func cancelPushNotification(for identifier: String) {
		print("NOTIFICAÇÃO CANCELADA")
		UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
	}
	
	/// Agenda as notificações de acordo com as datas de consumo do Product.
	/// - Parameter product: Produto a ter suas notificações agendadas.
	/// - Parameter cancelAllNotifications: Cancela todas notificações do produto quando verdadeiro
	static func notificationScheduler(for product: Product, cancelAllNotifications: Bool = false) {
		requestNotificationAuth()
		let timeUntilExpired = product.getTimeUntilExpired()
		let openTimeRemaining = product.getOpenTimeRemaining()
		
		//OPABTEX -> OPEN DATE ABOUT TO EXPIRE
		makePushNotification(
			title: "\(product.name) expira em breve",
			description: "Está aberto à \(Int(openTimeRemaining/86400)) dias e irá expirar amanhã, aproveite!",
			timeInterval: openTimeRemaining - 86400,
			identifier: "\(product.id.uuidString)OPABTEX") {
				cancelAllNotifications ? false : openTimeRemaining - 86400 > 0 && product.alreadyOpen
			}
		//OPEX -> OPEN DATE EXPIRED
		makePushNotification(
			title: "\(product.name) expirou!",
			description: "Está aberto à \(Int(openTimeRemaining/86400)+1) dias e expirou hoje! Recomendamos descartar.",
			timeInterval: openTimeRemaining,
			identifier: "\(product.id.uuidString)OPEX") {
				cancelAllNotifications ? false : openTimeRemaining > 0 && product.alreadyOpen
			}
		
		//EXABTEX -> EXPIRE DATE ABOUT EXPIRE
		makePushNotification(
			title:  "\(product.name) expira em breve",
			description: "Irá expirar em 3 dias, aproveite!",
			timeInterval: TimeInterval(timeUntilExpired - (3 * 86400)),
			identifier: "\(product.id.uuidString)EXABTEX") {
				cancelAllNotifications ? false : timeUntilExpired - (3 * 86400) > 0
			}
		
		//EX -> EXPIRED
		makePushNotification(
			title: "\(product.name) expirou",
			description: "Recomendamos descartar!",
			timeInterval: TimeInterval(timeUntilExpired),
			identifier: "\(product.id.uuidString)EX") {
				cancelAllNotifications ? false : timeUntilExpired > 0
			}
	}
}
