import SwiftUI

@main
struct JobApp: App {
	private let jobService: JobServiceProtocol = SampleJobService()

	var body: some Scene {
		WindowGroup {
			JobList(viewModel: JobsViewModel(jobService: jobService))
		}
	}
}
