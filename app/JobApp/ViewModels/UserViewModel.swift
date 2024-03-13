import SwiftUI
import Networking

@MainActor
protocol UserViewModelProtocol: ObservableObject {
	var userId: User.ID? { get }
	var state: UserViewState { get }
	var saveButtonState: UserViewSaveButtonState { get }
	var presentedError: LocalizedAlertError? { get set }

	func save(template: UserTemplate)
	func login(withId id: User.ID)
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
	SessionManager: SessionManagerProtocol,
	ConfigurationService: ConfigurationServiceProtocol,
	UserService: UserServiceProtocol
>: UserViewModelProtocol {
	@Published var userId: User.ID?
	@Published var state = UserViewState.loading
	@Published var saveButtonState = UserViewSaveButtonState.ready
	@Published var presentedError: LocalizedAlertError?

	private let sessionManager: SessionManager
	private let configurationService: ConfigurationService
	private let userService: UserService

	init(sessionManager: SessionManager, configurationService: ConfigurationService, userService: UserService) {
		self.userId = configurationService.get(Configuration.currentUserId)
		self.sessionManager = sessionManager
		self.configurationService = configurationService
		self.userService = userService

		Task {
			do {
				if let userId = userId {
					setUser(try await userService.getUser(withId: userId))
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
				if let userId {
					setUser(try await userService.updateUser(User(id: userId, template: template)))
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

	func login(withId id: User.ID) {
		let oldState = state
		state = .loading
		Task {
			do {
				setUser(try await userService.getUser(withId: id))
			} catch {
				state = oldState
			}
		}
	}

	func logout() {
		setUser(nil)
	}

	private func setUser(_ user: User?) {
		userId = user?.id
		configurationService.set(user?.id, for: Configuration.currentUserId)
		state = .ready(user.map(UserTemplate.init) ?? UserTemplate())
		sessionManager.user = user
	}
}

class SampleUserViewModel: UserViewModelProtocol {
	private let userService = SampleUserService()
	var userId: User.ID?
	let state: UserViewState
	let saveButtonState: UserViewSaveButtonState = .ready
	var presentedError: LocalizedAlertError?

	init(loggedIn: Bool) {
		do {
			let user = try userService.getUser(withId: loggedIn ? 1 : 0)
			userId = user.id
			state = .ready(UserTemplate(user: user))
		} catch let error as HttpError where error.status == .notFound {
			state = .ready(UserTemplate())
		} catch {
			state = .error(message: error.localizedDescription)
		}
	}

	func save(template: UserTemplate) {
		do {
			if let userId {
				_ = try userService.updateUser(User(id: userId, template: template))
			} else {
				userId = try userService.createUser(from: template).id
			}
		} catch {
			fatalError("Failed to save user: \(error)")
		}
	}

	func login(withId id: User.ID) {}
	func logout() {}
}
