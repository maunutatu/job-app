import Foundation

public protocol HttpNetworking {
	func perform(
		method: HttpMethod,
		host: String,
		path: String,
		payload: Data?
	) async throws -> Data
}
