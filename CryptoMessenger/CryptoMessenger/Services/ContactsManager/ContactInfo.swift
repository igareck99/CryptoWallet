import Foundation

// MARK: - ContactInfo(Identifiable)

struct ContactInfo: Identifiable {
	let id = UUID().uuidString
	let firstName: String
	let lastName: String
	let phoneNumber: String
	var imageData: Data?
}
