import SwiftUI

@MainActor
protocol JobsViewModelProtocol: ObservableObject {
	var state: JobsViewState { get }
	var searchText: String { get set }
}

enum JobsViewState {
	case loading
	case success(jobs: [Job])
	case error(message: String)
}

class JobsViewModel: JobsViewModelProtocol, ObservableObject {
	@Published var state = JobsViewState.loading
	@Published var searchText = "" {
		didSet { filtersChanged() }
	}

	private let jobService: JobServiceProtocol
	private var jobs = [Job]()

	init(jobService: JobServiceProtocol) {
		self.jobService = jobService

		Task {
			do {
				jobs = try await jobService.jobs()
				state = .success(jobs: filteredJobs)
			} catch {
				state = .error(message: error.localizedDescription)
			}
		}
	}

	private var filteredJobs: [Job] {
		searchText.isEmpty ? jobs : jobs.filter {
			let content = [$0.title, $0.description, $0.company, $0.employmentType]
			return content.contains { $0.contains(searchText) }
		}
	}

	private func filtersChanged() {
		guard case .success = state else { return }
		state = .success(jobs: filteredJobs)
	}
}

class JobsViewModelPreview: JobsViewModelProtocol {
	let state = JobsViewState.success(jobs: PreviewData.sampleJobs)
	var searchText = ""
}
