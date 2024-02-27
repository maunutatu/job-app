import Foundation

struct Job: Identifiable, Codable, Hashable {
	let id: Int
	let title: String
	let description: String
	let salary: Decimal
	let company: String
	let datePosted: Date
	let startDate: Date
	let endDate: Date?
	let location: String
	let field: String
	let workingHours: String
	let employmentType: String

	enum CodingKeys: String, CodingKey {
		case id = "ID"
		case title = "Title"
		case description = "Description"
		case salary = "Salary"
		case company = "Company"
		case datePosted = "DatePosted"
		case startDate = "StartDate"
		case endDate = "EndDate"
		case location = "Location"
		case field = "Field"
		case workingHours = "WorkingHours"
		case employmentType = "EmploymentType"
	}

	static let dateFormatter = configure(DateFormatter()) {
		$0.dateFormat = "yyyy-MM-dd"
		$0.timeZone = TimeZone(secondsFromGMT: 0)
	}
}
