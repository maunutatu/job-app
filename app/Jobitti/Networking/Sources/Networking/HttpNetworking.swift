import Foundation

public protocol HttpNetworking {
	func perform(
		method: HttpMethod,
		scheme: String,
		host: String,
		path: String,
		payload: Data?
	) async throws -> Data
}

public extension HttpNetworking {
	func perform(
		method: HttpMethod,
		scheme: String = "https",
		host: String,
		path: String,
		payload: Data? = nil
	) async throws -> Data {
		try await perform(method: method, scheme: scheme, host: host, path: path, payload: payload)
	}
}
