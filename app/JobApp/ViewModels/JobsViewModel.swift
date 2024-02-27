import SwiftUI
import Combine

@MainActor
protocol JobsViewModelProtocol: ObservableObject {
	associatedtype SomeFiltersViewModel: FiltersViewModelProtocol

	var filtersViewModel: SomeFiltersViewModel { get }
	var state: JobsViewState { get }
	var searchText: String { get set }
}

enum JobsViewState {
	case loading
	case success(jobs: [Job])
	case error(message: String)
}

class JobsViewModel: JobsViewModelProtocol, ObservableObject {
	let filtersViewModel = FiltersViewModel()

	@Published var state = JobsViewState.loading
	@Published var searchText = ""

	private var rawState = PassthroughSubject<JobsViewState, Never>()
	private let jobService: JobServiceProtocol
	private var jobs = [Job]()
	private var cancellables = Set<AnyCancellable>()

	init(jobService: JobServiceProtocol) {
		self.jobService = jobService

		rawState
			.combineLatest($searchText, filtersViewModel.$locations, filtersViewModel.$employmentTypes)
			.map(filteredState)
			.assign(to: \.state, on: self)
			.store(in: &cancellables)

		Task {
			do {
				jobs = try await jobService.jobs()
				filtersViewModel.jobs = jobs
				rawState.send(.success(jobs: jobs))
			} catch {
				rawState.send(.error(message: error.localizedDescription))
			}
		}
	}

	private func filteredState(
		_ state: JobsViewState,
		searchText: String,
		locations: [LocationState],
		employmentTypes: [EmploymentTypeState]
	) -> JobsViewState {
		guard case .success(let jobs) = state else { return state }

		let filteredJobs = jobs.filter {
			let content = [$0.title, $0.description, $0.company, $0.employmentType]
			let enabledLocations = filtersViewModel.locations.filter(\.isEnabled).map(\.name)
			let enabledEmploymentTypes = filtersViewModel.employmentTypes.filter(\.isEnabled).map(\.name)

			let contentMatches = searchText.isEmpty || content.contains { $0.contains(searchText) }
			let locationMatches = enabledLocations.isEmpty || enabledLocations.contains($0.location)
			let employmentTypeMatches = enabledEmploymentTypes.isEmpty || enabledEmploymentTypes.contains($0.employmentType)

			return contentMatches && locationMatches && employmentTypeMatches
		}

		return .success(jobs: filteredJobs)
	}
}

class JobsViewModelPreview: JobsViewModelProtocol {
	let filtersViewModel = FiltersViewModel()
	let state = JobsViewState.success(jobs: PreviewData.sampleJobs)
	var searchText = ""
}
