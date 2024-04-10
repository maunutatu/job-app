import SwiftUI
import Networking

@MainActor
protocol UserViewModelProtocol: ObservableObject {
	var username: String? { get }
	var state: UserViewState { get }
	var saveButtonState: UserViewSaveButtonState { get }
	var presentedError: LocalizedAlertError? { get set }

	func save(template: UserTemplate)
	func login(withUsername username: String)
	func logout()
}

enum UserViewState: Equatable {
	case loading
	case ready(UserTemplate)
	case error(message: String)
}

enum UserViewSaveButtonState {
	case loading
	case ready
	case error(message: String)
}

class UserViewModel<
	ConfigurationService: ConfigurationServiceProtocol,
	UserService: UserServiceProtocol
>: UserViewModelProtocol {
	@Published var username: String?
	@Published var state = UserViewState.loading
	@Published var saveButtonState = UserViewSaveButtonState.ready
	@Published var presentedError: LocalizedAlertError?

	private let session: Session
	private let configurationService: ConfigurationService
	private let userService: UserService

	init(session: Session, configurationService: ConfigurationService, userService: UserService) {
		self.username = configurationService.get(Configuration.currentUsername)
		self.session = session
		self.configurationService = configurationService
		self.userService = userService

		Task {
			do {
				if let username {
					setUser(try await userService.getUser(withUsername: username))
				} else {
					setUser(nil)
				}
			} catch {
				state = .error(message: error.localizedDescription)
			}
		}
	}

	func save(template: UserTemplate) {
		saveButtonState = .loading
		Task {
			do {
				if let username {
					let user = try await userService.getUser(withUsername: username)
					let updatedUser = try await userService.updateUser(User(id: user.id, template: template))
					setUser(try await userService.getUser(withUsername: updatedUser.username))
				} else {
					setUser(try await userService.createUser(from: template))
				}
				saveButtonState = .ready
			} catch {
				saveButtonState = .ready
				presentedError = LocalizedAlertError(error: error)
			}
		}
	}

	func login(withUsername username: String) {
		let oldState = state
		state = .loading
		Task {
			do {
				setUser(try await userService.getUser(withUsername: username))
			} catch {
				state = oldState
			}
		}
	}

	func logout() {
		setUser(nil)
	}

	private func setUser(_ user: User?) {
		username = user?.username
		configurationService.set(user?.username, for: Configuration.currentUsername)
		state = .ready(user.map(UserTemplate.init) ?? UserTemplate())
		session.user = user
	}
}

class SampleUserViewModel: UserViewModelProtocol {
	private let userService = SampleUserService()
	var username: String?
	let state: UserViewState
	let saveButtonState: UserViewSaveButtonState = .ready
	var presentedError: LocalizedAlertError?

	init(loggedIn: Bool) {
		do {
			let user = try userService.getUser(withUsername: loggedIn ? "JohnDoe" : "Nobody")
			username = user.username
			state = .ready(UserTemplate(user: user))
		} catch let error as HttpError where error.status == .notFound {
			state = .ready(UserTemplate())
		} catch {
			state = .error(message: error.localizedDescription)
		}
	}

	func save(template: UserTemplate) {
		do {
			if let username {
				let user = try userService.getUser(withUsername: username)
				let updatedUser = try userService.updateUser(User(id: user.id, template: template))
				self.username = updatedUser.username
			} else {
				username = try userService.createUser(from: template).username
			}
		} catch {
			fatalError("Failed to save user: \(error)")
		}
	}

	func login(withUsername username: String) {}
	func logout() {}
}
