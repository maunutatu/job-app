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
	JobService: JobServiceProtocol,
	UserService: UserServiceProtocol
>: JobViewModelProtocol {
	let job: Job
	@Published var state: JobViewState
	@Published var presentedError: LocalizedAlertError?

	private let session: Session
	private let jobService: JobService
	private let userService: UserService

	init(session: Session, jobService: JobService, userService: UserService, job: Job) {
		self.job = job
		self.session = session
		self.jobService = jobService
		self.userService = userService

		if let user = session.user {
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
				session.user = try? await userService.getUser(withId: user.id)
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
