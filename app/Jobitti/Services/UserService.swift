import Foundation
import Networking

protocol UserServiceProtocol {
	func getUser(withUsername username: String) async throws -> User
	func createUser(from template: UserTemplate) async throws -> User
	func updateUser(_ user: User) async throws -> User
}

class UserService<Networking: HttpNetworking>: UserServiceProtocol {
	private let host: String
	private let networking: Networking

	private let decoder = configure(JSONDecoder()) {
		$0.dateDecodingStrategy = .formatted(Job.dateFormatter)
	}

	private let encoder = configure(JSONEncoder()) {
		$0.dateEncodingStrategy = .formatted(Job.dateFormatter)
	}

	init(host: String, networking: Networking) {
		self.host = host
		self.networking = networking
	}

	func getUser(withUsername username: String) async throws -> User {
		try decoder.decode(User.self, from: await networking.perform(
			method: .get,
			scheme: "http",
			host: host,
			path: "/users/\(username)"
		))
	}

	func createUser(from template: UserTemplate) async throws -> User {
		try decoder.decode(User.self, from: await networking.perform(
			method: .post,
			scheme: "http",
			host: host,
			path: "/users",
			payload: encoder.encode(template)
		))
	}

	func updateUser(_ user: User) async throws -> User {
		try decoder.decode(User.self, from: await networking.perform(
			method: .put,
			scheme: "http",
			host: host,
			path: "/users",
			payload: encoder.encode(user)
		))
	}
}

class SampleUserService: UserServiceProtocol {
	private let decoder = configure(JSONDecoder()) {
		$0.dateDecodingStrategy = .formatted(Job.dateFormatter)
	}

	private var users: [User]

	init() {
		guard let url = Bundle.main.url(forResource: "SampleUsers", withExtension: "json") else {
			fatalError("Sample data file not found")
		}

		do {
			let data = try Data(contentsOf: url)
			users = try decoder.decode([User].self, from: data)
		} catch {
			fatalError("Failed to parse sample users: \(error)")
		}
	}

	func getUser(withUsername username: String) throws -> User {
		guard let user = users.first(where: { $0.username == username }) else {
			throw HttpError.sampleDataError(code: 404)
		}
		return user
	}

	func createUser(from template: UserTemplate) throws -> User {
		var id = 1
		while true {
			guard users.contains(where: { $0.id == id }) else {
				break
			}
			id += 1
		}
		let user = User(id: id, template: template)
		users.append(user)
		return user
	}

	func updateUser(_ user: User) throws -> User {
		guard let index = users.firstIndex(where: { $0.id == user.id }) else {
			throw HttpError.sampleDataError(code: 404)
		}
		users[index] = user
		return user
	}
}
