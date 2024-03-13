import Foundation

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
	SessionManager: SessionManagerProtocol,
	JobService: JobServiceProtocol,
	UserService: UserServiceProtocol
>: JobViewModelProtocol {
	let job: Job
	@Published var state: JobViewState
	@Published var presentedError: LocalizedAlertError?

	private let sessionManager: SessionManager
	private let jobService: JobService
	private let userService: UserService

	init(sessionManager: SessionManager, jobService: JobService, userService: UserService, job: Job) {
		self.job = job
		self.sessionManager = sessionManager
		self.jobService = jobService
		self.userService = userService

		if let user = sessionManager.user {
			if let applications = user.jobApplications, applications.contains(where: { $0.jobId == job.id }) {
				state = .applicationSent
			} else {
				state = .loggedIn(skills: user.skills)
			}
		} else {
			state = .notLoggedIn
		}
	}

	func sendApplication(coverLetter: String, relevantSkills: [String]) {
		guard let user = sessionManager.user else { return }

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
				sessionManager.user = try? await userService.getUser(withId: user.id)
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
