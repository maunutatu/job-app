import Foundation
import Combine

@MainActor
protocol FiltersViewModelProtocol: ObservableObject {
	var locations: [FilterState] { get set }
	var employmentTypes: [FilterState] { get set }
	var fields: [FilterState] { get set }
	var activeFilterCount: Int { get }

	func clearFilters()
}

struct FilterState {
	let name: String
	var isEnabled: Bool
}

class FiltersViewModel: FiltersViewModelProtocol, ObservableObject {
	@Published var locations = [FilterState]()
	@Published var employmentTypes = [FilterState]()
	@Published var fields = [FilterState]()
	@Published var jobs = [Job]()
	@Published var activeFilterCount = 0

	private var cancellables = Set<AnyCancellable>()

	init() {
		$jobs.map { Self.createFilters(for: \.location, from: $0) }
			.assign(to: \.locations, on: self)
			.store(in: &cancellables)

		$jobs.map { Self.createFilters(for: \.employmentType, from: $0) }
			.assign(to: \.employmentTypes, on: self)
			.store(in: &cancellables)

		$jobs.map { Self.createFilters(for: \.field, from: $0) }
			.assign(to: \.fields, on: self)
			.store(in: &cancellables)

		Publishers.CombineLatest3($locations, $employmentTypes, $fields)
			.map { ($0.0 + $0.1 + $0.2).filter(\.isEnabled).count }
			.assign(to: \.activeFilterCount, on: self)
			.store(in: &cancellables)
	}

	func clearFilters() {
		let reset: ([FilterState]) -> [FilterState] = {
			$0.map {
				FilterState(name: $0.name, isEnabled: false)
			}
		}

		locations = reset(locations)
		employmentTypes = reset(employmentTypes)
		fields = reset(fields)
	}

	private static func createFilters<T>(for keyPath: KeyPath<T, String>, from objects: [T]) -> [FilterState] {
		getUniques(keyPath, from: objects).map { FilterState(name: $0, isEnabled: false) }
	}

	private static func getUniques<T, U: Hashable & Comparable>(_ keyPath: KeyPath<T, U>, from objects: [T]) -> [U] {
		objects.reduce(into: Set()) { result, object in
			result.insert(object[keyPath: keyPath])
		}.sorted()
	}
}
