import Foundation

struct User: Identifiable, Codable, Hashable {
	let id: Int
	let username: String
	let firstName: String
	let lastName: String
	let phoneNumber: String
	let email: String
	let dateOfBirth: Date
	let experience: [String]
	let education: String
	let skills: [String]
	let jobApplications: [JobApplication]?

	enum CodingKeys: String, CodingKey {
		case id = "ID"
		case username = "Username"
		case firstName = "FirstName"
		case lastName = "LastName"
		case phoneNumber = "PhoneNumber"
		case email = "Email"
		case dateOfBirth = "DateOfBirth"
		case experience = "Experience"
		case education = "Education"
		case skills = "Skills"
		case jobApplications = "JobApplications"
	}
}

struct UserTemplate: Encodable, Equatable {
	let username: String
	let firstName: String
	let lastName: String
	let phoneNumber: String
	let email: String
	let dateOfBirth: Date
	let experience: [String]
	let education: String
	let skills: [String]

	internal init(username: String, firstName: String, lastName: String, phoneNumber: String, email: String, dateOfBirth: Date, experience: [String], education: String, skills: [String]) {
		self.username = username
		self.firstName = firstName
		self.lastName = lastName
		self.phoneNumber = phoneNumber
		self.email = email
		self.dateOfBirth = dateOfBirth
		self.experience = experience
		self.education = education
		self.skills = skills
	}

	init() {
		username = ""
		firstName = ""
		lastName = ""
		phoneNumber = ""
		email = ""
		dateOfBirth = Date()
		experience = []
		education = ""
		skills = []
	}
}

extension User {
	init(id: User.ID, template: UserTemplate) {
		self.id = id
		username = template.username
		firstName = template.firstName
		lastName = template.lastName
		phoneNumber = template.phoneNumber
		email = template.email
		dateOfBirth = template.dateOfBirth
		experience = template.experience
		education = template.education
		skills = template.skills
		jobApplications = []
	}
}

extension UserTemplate {
	init(user: User) {
		username = user.username
		firstName = user.firstName
		lastName = user.lastName
		phoneNumber = user.phoneNumber
		email = user.email
		dateOfBirth = user.dateOfBirth
		experience = user.experience
		education = user.education
		skills = user.skills
	}
}
