import Foundation
import Networking

protocol JobServiceProtocol {
	func jobs() async throws -> [Job]
}

class JobService<Networking: HttpNetworking>: JobServiceProtocol {
	private let host: String
	private let networking: Networking

	private let decoder = configure(JSONDecoder()) {
		$0.dateDecodingStrategy = .formatted(Job.dateFormatter)
	}

	init(host: String, networking: Networking) {
		self.host = host
		self.networking = networking
	}

	func jobs() async throws -> [Job] {
		try decoder.decode([Job].self, from: await networking.perform(
			method: .get,
			host: host,
			path: "/jobListings",
			payload: nil
		))
	}
}

class SampleJobService: JobServiceProtocol {
	private let decoder = configure(JSONDecoder()) {
		$0.dateDecodingStrategy = .formatted(Job.dateFormatter)
	}

	func jobs() async throws -> [Job] {
		guard let url = Bundle.main.url(forResource: "SampleJobs", withExtension: "json") else {
			fatalError("Sample data file not found")
		}

		let data = try Data(contentsOf: url)
		return try decoder.decode([Job].self, from: data)
	}
}
