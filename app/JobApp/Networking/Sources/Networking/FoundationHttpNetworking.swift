import Foundation

public struct FoundationHttpNetworking: HttpNetworking {
	private let session: URLSession

	public init(session: URLSession = .shared) {
		self.session = session
	}

	public func perform(method: HttpMethod, host: String, path: String, payload: Data?) async throws -> Data {
		var components = URLComponents()
		components.scheme = "https"
		components.host = host

		guard let url = components.url else {
			fatalError("Failed to create URL from components \(components)")
		}

		var request = URLRequest(url: url)
		request.httpMethod = method.value

		let (data, response) = try await session.data(for: request)

		if let httpResponse = response as? HTTPURLResponse, !(200 ... 299).contains(httpResponse.statusCode) {
			throw HttpError(statusCode: httpResponse.statusCode)
		}

		return data
	}
}

extension HttpMethod {
	var value: String {
		switch self {
			case .get: return "GET"
		}
	}
}
