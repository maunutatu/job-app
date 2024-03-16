enum JobSchedule: Equatable, Codable, Hashable {
	case flexible
	case hours(start: Int, end: Int)
	case other(String)

	init(from decoder: any Decoder) throws {
		let container = try decoder.singleValueContainer()
		switch try container.decode(String.self) {
			case "Joustava":
				self = .flexible
			case let string:
				if
					let match = try /(?<start>\d+)-(?<end>\d+)/.wholeMatch(in: string),
					let start = Int(match.start),
					let end = Int(match.end)
				{
					self = .hours(start: start, end: end)
				} else {
					self = .other(string)
				}
		}
	}

	func encode(to encoder: any Encoder) throws {
		var container = encoder.singleValueContainer()
		switch self {
			case .flexible:
				try container.encode("Joustava")
			case let .hours(start: start, end: end):
				try container.encode("\(start)-\(end)")
			case let .other(string):
				try container.encode(string)
		}
	}

	var description: String {
		switch self {
			case .flexible:
				return String(localized: "job.schedule.flexible")
			case let .hours(start: start, end: end):
				return "\(start)-\(end)"
			case let .other(string):
				return string
		}
	}
}
