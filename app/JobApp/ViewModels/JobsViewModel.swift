import SwiftUI

@MainActor
protocol JobsViewModelProtocol: ObservableObject {
	var state: JobsViewState { get }
}

enum JobsViewState {
	case loading
	case success(jobs: [Job])
	case error(message: String)
}

class JobsViewModel: JobsViewModelProtocol, ObservableObject {
	@Published var state = JobsViewState.loading

	private let jobService: JobServiceProtocol

	init(jobService: JobServiceProtocol) {
		self.jobService = jobService

		Task {
			do {
				state = .success(jobs: try await jobService.jobs())
			} catch {
				state = .error(message: error.localizedDescription)
			}
		}
	}
}

class JobsViewModelPreview: JobsViewModelProtocol {
	let state = JobsViewState.success(jobs: PreviewData.sampleJobs)
}
