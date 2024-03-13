import SwiftUI
import Combine

@MainActor
protocol JobsViewModelProtocol: ObservableObject {
	associatedtype SomeFiltersViewModel: FiltersViewModelProtocol
	associatedtype SomeApplicationsViewModel: ApplicationsViewModelProtocol
	associatedtype SomeUserViewModel: UserViewModelProtocol
	associatedtype SomeJobViewModel: JobViewModelProtocol

	var filtersViewModel: SomeFiltersViewModel { get }
	var applicationsViewModel: SomeApplicationsViewModel { get }
	var userViewModel: SomeUserViewModel { get }
	var state: JobsViewState { get }
	var searchText: String { get set }
	var activeFilterCount: Int { get }

	func jobViewModel(for job: Job) -> SomeJobViewModel
}

enum JobsViewState {
	case loading
	case success(jobs: [Job])
	case error(message: String)
}

class JobsViewModel<
	ConfigurationService: ConfigurationServiceProtocol,
	JobService: JobServiceProtocol,
	UserService: UserServiceProtocol
>: JobsViewModelProtocol, ObservableObject {
	@ObservedObject var filtersViewModel: FiltersViewModel
	@ObservedObject var applicationsViewModel: ApplicationsViewModel
	@ObservedObject var userViewModel: UserViewModel<ConfigurationService, UserService>

	@Published var state = JobsViewState.loading
	@Published var user: User?
	@Published var searchText = ""
	@Published var activeFilterCount = 0

	private var rawState = PassthroughSubject<JobsViewState, Never>()
	private let session: Session
	private let jobService: JobService
	private let userService: UserService
	private var jobs = [Job]()
	private var cancellables = Set<AnyCancellable>()

	init(session: Session, configurationService: ConfigurationService, jobService: JobService, userService: UserService) {
		self.session = session
		self.jobService = jobService
		self.userService = userService
		self.filtersViewModel = FiltersViewModel()
		self.applicationsViewModel = ApplicationsViewModel(session: session)
		self.userViewModel = UserViewModel(
			session: session,
			configurationService: configurationService,
			userService: userService
		)

		rawState
			.combineLatest($searchText)
			.combineLatest(filtersViewModel.$locations, filtersViewModel.$employmentTypes, filtersViewModel.$fields)
			.map { Self.filteredState($0.0.0, searchText: $0.0.1, locations: $0.1, employmentTypes: $0.2, fields: $0.3) }
			.assign(to: \.state, on: self)
			.store(in: &cancellables)

		filtersViewModel.$activeFilterCount
			.assign(to: \.activeFilterCount, on: self)
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

	private static func filteredState(
		_ state: JobsViewState,
		searchText: String,
		locations: [FilterState],
		employmentTypes: [FilterState],
		fields: [FilterState]
	) -> JobsViewState {
		guard case .success(let jobs) = state else { return state }

		let filteredJobs = jobs.filter {
			let content = [$0.title, $0.description, $0.company, $0.employmentType]
			let enabledLocations = locations.filter(\.isEnabled).map(\.name)
			let enabledEmploymentTypes = employmentTypes.filter(\.isEnabled).map(\.name)
			let enabledFields = fields.filter(\.isEnabled).map(\.name)

			let contentMatches = searchText.isEmpty || content.contains { $0.contains(searchText) }
			let locationMatches = enabledLocations.isEmpty || enabledLocations.contains($0.location)
			let employmentTypeMatches = enabledEmploymentTypes.isEmpty || enabledEmploymentTypes.contains($0.employmentType)
			let fieldMatches = enabledFields.isEmpty || enabledFields.contains($0.field)

			return contentMatches && locationMatches && employmentTypeMatches && fieldMatches
		}

		return .success(jobs: filteredJobs)
	}

	func jobViewModel(for job: Job) -> JobViewModel<JobService, UserService> {
		JobViewModel(session: session, jobService: jobService, userService: userService, job: job)
	}
}

class JobsViewModelPreview: JobsViewModelProtocol {
	let filtersViewModel = FiltersViewModel()
	let applicationsViewModel = SampleApplicationsViewModel()
	let userViewModel = SampleUserViewModel(loggedIn: true)
	let state = JobsViewState.success(jobs: PreviewData.sampleJobs)
	var searchText = ""
	let activeFilterCount = 0

	func jobViewModel(for job: Job) -> SampleJobViewModel {
		SampleJobViewModel(job: job)
	}
}
