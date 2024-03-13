import SwiftUI
import Networking

@main
struct JobApp: App {
	private let networking: FoundationHttpNetworking
	private let session: Session
	private let configurationService: ConfigurationService
	private let jobService: JobService<FoundationHttpNetworking>
	private let userService: UserService<FoundationHttpNetworking>

	init() {
		let host = "54.229.63.179"
		networking = FoundationHttpNetworking()
		session = Session()
		configurationService = ConfigurationService(userDefaults: .standard)
		jobService = JobService(host: host, networking: networking)
		userService = UserService(host: host, networking: networking)
	}

	var body: some Scene {
		WindowGroup {
			JobList(
				viewModel: JobsViewModel(
					session: session,
					configurationService: configurationService,
					jobService: jobService,
					userService: userService
				)
			)
		}
	}
}

enum GlobalConstant {
	static let appName = "Jobitti"
}
