import Foundation
import Combine

@MainActor
protocol JobViewModelProtocol: ObservableObject {
	var job: Job { get }
	var state: JobViewState { get }
	var presentedError: LocalizedAlertError? { get set }

	func sendApplication(coverLetter: String, relevantSkills: [String])
}

enum JobViewState: Equatable {
	case notLoggedIn
	case loggedIn(skills: [String])
	case applicationSent
}

class JobViewModel<
	JobService: JobServiceProtocol,
	UserService: UserServiceProtocol
>: JobViewModelProtocol {
	let job: Job
	@Published var state: JobViewState = .notLoggedIn
	@Published var presentedError: LocalizedAlertError?

	private let session: Session
	private let jobService: JobService
	private let userService: UserService

	private var cancellables = Set<AnyCancellable>()

	init(session: Session, jobService: JobService, userService: UserService, job: Job) {
		self.job = job
		self.session = session
		self.jobService = jobService
		self.userService = userService

		session.$user
			.dropFirst()
			.map { Self.state(user: $0, job: job) }
			.assign(to: \.state, on: self)
			.store(in: &cancellables)
	}

	private static func state(user: User?, job: Job) -> JobViewState {
		guard let user = user else { return .notLoggedIn }

		if let applications = user.jobApplications, applications.contains(where: { $0.jobId == job.id }) {
			return .applicationSent
		} else {
			return .loggedIn(skills: user.skills)
		}
	}

	func sendApplication(coverLetter: String, relevantSkills: [String]) {
		guard let user = session.user else { return }

		let template = JobApplicationTemplate(
			userId: user.id,
			jobId: job.id,
			coverLetter: coverLetter,
			status: "sent",
			sentDate: .now,
			relevantSkills: relevantSkills
		)

		Task {
			do {
				_ = try await jobService.sendApplication(template)
				session.user = try? await userService.getUser(withUsername: user.username)
				state = .applicationSent
			} catch {
				presentedError = LocalizedAlertError(error: error)
			}
		}
	}
}

class SampleJobViewModel: JobViewModelProtocol {
	let job: Job
	var state: JobViewState
	var presentedError: LocalizedAlertError?

	init(job: Job) {
		self.job = job
		self.state = .loggedIn(skills: PreviewData.sampleUser.skills)
	}

	func sendApplication(coverLetter: String, relevantSkills: [String]) {}
}
