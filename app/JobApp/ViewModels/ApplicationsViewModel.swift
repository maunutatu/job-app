import Combine

@MainActor
protocol ApplicationsViewModelProtocol: ObservableObject {
	var state: ApplicationsViewState { get }
	var presentedError: LocalizedAlertError? { get set }
}

enum ApplicationsViewState: Equatable {
	case notLoggedIn
	case ready(applications: [JobApplication])
}

class ApplicationsViewModel: ApplicationsViewModelProtocol {
	@Published var state: ApplicationsViewState = .notLoggedIn
	@Published var presentedError: LocalizedAlertError?

	private var session: Session

	private var cancellables: Set<AnyCancellable> = []

	init(session: Session) {
		self.session = session

		session.$user.map { user in
			guard let user else {
				return .notLoggedIn
			}
			return .ready(applications: user.jobApplications ?? [])
		}
		.assign(to: \.state, on: self)
		.store(in: &cancellables)
	}
}

class SampleApplicationsViewModel: ApplicationsViewModelProtocol {
	@Published var state: ApplicationsViewState = .ready(applications: [
		JobApplication(
			id: 1,
			userId: 1,
			jobId: 1,
			coverLetter: "Hello can I work here?",
			status: "sent",
			sentDate: .now,
			relevantSkills: ["Swift", "SwiftUI"],
			jobTitle: "iOS Developer",
			company: "Apple"
		),
		JobApplication(
			id: 2,
			userId: 1,
			jobId: 2,
			coverLetter: "I think I'm a good fit for this role!",
			status: "sent",
			sentDate: .distantPast,
			relevantSkills: ["SQL", "Python"],
			jobTitle: "Backend Engineer",
			company: "Microsoft"
		)
	])

	@Published var presentedError: LocalizedAlertError?
}
