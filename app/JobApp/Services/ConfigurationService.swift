import Foundation

protocol ConfigurationServiceProtocol {
	func get<T>(_ key: Configuration.Key<T>) -> T?
	func set<T>(_ value: T?, for key: Configuration.Key<T>)
}

enum Configuration {
	struct Key<T> {
		let name: String

		fileprivate init(_ name: String) {
			self.name = name
		}
	}

	static let currentUserId = Key<User.ID>("currentUserId")
}

class ConfigurationService: ConfigurationServiceProtocol {
	private let userDefaults: UserDefaults

	init(userDefaults: UserDefaults) {
		self.userDefaults = userDefaults
	}

	func get<T>(_ key: Configuration.Key<T>) -> T? {
		userDefaults.value(forKey: key.name) as? T
	}

	func set<T>(_ value: T?, for key: Configuration.Key<T>) {
		userDefaults.setValue(value, forKey: key.name)
	}
}

class SampleConfigurationService: ConfigurationServiceProtocol {
	private var configuration = [String: Any]()

	func get<T>(_ key: Configuration.Key<T>) -> T? {
		configuration[key.name] as? T
	}

	func set<T>(_ value: T?, for key: Configuration.Key<T>) {
		configuration[key.name] = value
	}
}
