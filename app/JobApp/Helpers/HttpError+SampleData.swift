import Foundation
import Networking

extension HttpError {
	static func sampleDataError(code: Int) -> HttpError {
		guard let url = URL(string: "sample-data") else {
			fatalError("Can't create sample URL")
		}
		return Self(url: url, statusCode: code)
	}
}
