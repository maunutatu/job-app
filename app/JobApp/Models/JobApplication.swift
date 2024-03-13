import Foundation

struct JobApplication: Identifiable, Codable, Hashable {
	let id: Int
	let userId: User.ID
	let jobId: Job.ID
	let coverLetter: String
	let status: String
	let sentDate: Date
	let relevantSkills: [String]
}

struct JobApplicationTemplate: Codable {
	let userId: User.ID
	let jobId: Job.ID
	let coverLetter: String
	let status: String
	let sentDate: Date
	let relevantSkills: [String]
}
