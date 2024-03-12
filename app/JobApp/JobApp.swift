import SwiftUI
import Networking

@main
struct JobApp: App {
	private let networking: FoundationHttpNetworking
	private let jobService: JobServiceProtocol

	init() {
		networking = FoundationHttpNetworking()
		jobService = JobService(host: "54.229.63.179", networking: networking)
	}

	var body: some Scene {
		WindowGroup {
			JobList(viewModel: JobsViewModel(jobService: jobService))
		}
	}
}
