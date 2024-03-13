import Foundation

struct JobApplication: Identifiable, Codable, Hashable {
	let id: Int
	let userId: User.ID
	let jobId: Job.ID
	let coverLetter: String
	let status: String
	let sentDate: Date
	let relevantSkills: [String]
	let jobTitle: String
	let company: String

	enum CodingKeys: String, CodingKey {
		case id = "ID"
		case userId = "User"
		case jobId = "JobListing"
		case coverLetter = "CoverLetter"
		case status = "Status"
		case sentDate = "SentDate"
		case relevantSkills = "RelevantSkills"
		case jobTitle = "JobTitle"
		case company = "Company"
	}
}

struct JobApplicationTemplate: Codable {
	let userId: User.ID
	let jobId: Job.ID
	let coverLetter: String
	let status: String
	let sentDate: Date
	let relevantSkills: [String]
}
