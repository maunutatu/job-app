import Foundation
import Networking

protocol JobServiceProtocol {
	func jobs() async throws -> [Job]
	func sendApplication(_ template: JobApplicationTemplate) async throws -> JobApplication
}

class JobService<Networking: HttpNetworking>: JobServiceProtocol {
	private let host: String
	private let networking: Networking

	private let decoder = configure(JSONDecoder()) {
		$0.dateDecodingStrategy = .formatted(Job.dateFormatter)
	}

	private let encoder = configure(JSONEncoder()) {
		$0.dateEncodingStrategy = .formatted(Job.dateFormatter)
	}

	init(host: String, networking: Networking) {
		self.host = host
		self.networking = networking
	}

	func jobs() async throws -> [Job] {
		try decoder.decode([Job].self, from: await networking.perform(
			method: .get,
			scheme: "http",
			host: host,
			path: "/job-listings",
			payload: nil
		))
	}

	func sendApplication(_ template: JobApplicationTemplate) async throws -> JobApplication {
		try decoder.decode(JobApplication.self, from: await networking.perform(
			method: .post,
			scheme: "http",
			host: host,
			path: "/job-application",
			payload: encoder.encode(template)
		))
	}
}

class SampleJobService: JobServiceProtocol {
	private let decoder = configure(JSONDecoder()) {
		$0.dateDecodingStrategy = .formatted(Job.dateFormatter)
	}

	func jobs() throws -> [Job] {
		guard let url = Bundle.main.url(forResource: "SampleJobs", withExtension: "json") else {
			fatalError("Sample data file not found")
		}

		let data = try Data(contentsOf: url)
		return try decoder.decode([Job].self, from: data)
	}

	func sendApplication(_ template: JobApplicationTemplate) async throws -> JobApplication {
		JobApplication(
			id: 1,
			userId: template.userId,
			jobId: template.jobId,
			coverLetter: template.coverLetter,
			status: template.status,
			sentDate: template.sentDate,
			relevantSkills: template.relevantSkills
		)
	}
}
