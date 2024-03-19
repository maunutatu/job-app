import Foundation

public struct HttpError: LocalizedError {
	public let url: URL
	public let statusCode: Int
	public let message: String?

	public init(url: URL, statusCode: Int, message: String? = nil) {
		self.url = url
		self.statusCode = statusCode
		self.message = message
	}

	public var status: HttpStatus {
		HttpStatus(code: statusCode)
	}

	public var errorDescription: String? {
		let message = message.map { "\n\n\($0)" } ?? ""
		return String(format: String(localized: "error.http"), statusCode, url.absoluteString) + message
	}
}

public enum HttpStatus: Int, CaseIterable {
	case ok = 200
	case notFound = 404
	case internalServerError = 500
	case other = -1

	public init(code: Int) {
		self = Self.allCases.first { $0.rawValue == code } ?? .other
	}
}
