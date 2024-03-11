import Foundation

public struct HttpError: LocalizedError {
	public let url: URL
	public let statusCode: Int

	public var errorDescription: String? {
		String(format: String(localized: "error.http"), statusCode, url.absoluteString)
	}
}
