import Foundation
import Combine

@MainActor
protocol FiltersViewModelProtocol: ObservableObject {
	var locations: [LocationState] { get set }
	var employmentTypes: [EmploymentTypeState] { get set }
	var fields: [FieldState] { get set }
}

class LocationState: ObservableObject {
	let name: String
	@Published var isEnabled: Bool

	init(name: String, isEnabled: Bool) {
		self.name = name
		self.isEnabled = isEnabled
	}
}

class EmploymentTypeState: ObservableObject {
	let name: String
	@Published var isEnabled: Bool

	init(name: String, isEnabled: Bool) {
		self.name = name
		self.isEnabled = isEnabled
	}
}

class FieldState: ObservableObject {
	let name: String
	@Published var isEnabled: Bool

	init(name: String, isEnabled: Bool) {
		self.name = name
		self.isEnabled = isEnabled
	}
}

class FiltersViewModel: FiltersViewModelProtocol, ObservableObject {
	@Published var locations = [LocationState]()
	@Published var employmentTypes = [EmploymentTypeState]()
	@Published var fields = [FieldState]()
	@Published var jobs = [Job]()

	private var cancellables = Set<AnyCancellable>()

	init() {
		$jobs.map {
			Self.getUniques(\.location, from: $0)
				.map { LocationState(name: $0, isEnabled: false) }
		}
		.assign(to: \.locations, on: self)
		.store(in: &cancellables)

		$jobs.map {
			Self.getUniques(\.employmentType, from: $0)
				.map { EmploymentTypeState(name: $0, isEnabled: false) }
		}
		.assign(to: \.employmentTypes, on: self)
		.store(in: &cancellables)

		$jobs.map {
			Self.getUniques(\.field, from: $0)
				.map { FieldState(name: $0, isEnabled: false) }
		}
		.assign(to: \.fields, on: self)
		.store(in: &cancellables)
	}

	private static func getUniques<T: Hashable & Comparable>(_ keyPath: KeyPath<Job, T>, from jobs: [Job]) -> [T] {
		jobs.reduce(into: Set()) { result, job in
			result.insert(job[keyPath: keyPath])
		}.sorted()
	}
}
