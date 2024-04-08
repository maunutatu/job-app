import SwiftUI
import Flow

struct FiltersView<ViewModel: FiltersViewModelProtocol>: View {
	@ObservedObject private var viewModel: ViewModel

	init(viewModel: ViewModel) {
		self.viewModel = viewModel
	}

	var body: some View {
		VStack(alignment: .leading, spacing: 32) {
			HStack {
				Text(String(format: String(localized: "filters.activeCount"), viewModel.activeFilterCount))
					.font(.caption)
				Spacer()
				Button(action: viewModel.clearFilters) {
					Text("filters.clearButton")
				}
				.disabled(viewModel.activeFilterCount == 0)
			}
			VStack(alignment: .leading) {
				Text("filters.location")
					.font(.headline)
				Divider()
				if let remoteIndex = viewModel.locations.firstIndex(where: { $0.name == "Etätyö" }) {
					Toggle(viewModel.locations[remoteIndex].name, isOn: $viewModel.locations[remoteIndex].isEnabled)
						.toggleStyle(.button)
					Divider()
				}
				HFlow {
					ForEach(Array(viewModel.locations.enumerated()), id: \.offset) { index, location in
						if location.name != "Etätyö" {
							Toggle(location.name, isOn: $viewModel.locations[index].isEnabled)
								.toggleStyle(.button)
						}
					}
				}
			}
			VStack(alignment: .leading) {
				Text("filters.employmentType")
					.font(.headline)
				Divider()
				HFlow {
					ForEach(Array(viewModel.employmentTypes.enumerated()), id: \.offset) { index, employmentType in
						Toggle(employmentType.name, isOn: $viewModel.employmentTypes[index].isEnabled)
							.toggleStyle(.button)
					}
				}
			}
			VStack(alignment: .leading) {
				Text("filters.field")
					.font(.headline)
				Divider()
				HFlow {
					ForEach(Array(viewModel.fields.enumerated()), id: \.offset) { index, field in
						Toggle(field.name, isOn: $viewModel.fields[index].isEnabled)
							.toggleStyle(.button)
					}
				}
			}
			VStack(alignment: .leading) {
				Text("filters.schedule")
					.font(.headline)
				Divider()
				HStack {
					Picker(selection: $viewModel.scheduleStart) {
						ForEach(0...23, id: \.self) {
							Text(verbatim: "\($0):00")
						}
					} label: {
						EmptyView()
					}
					.frame(width: 96)
					Text(verbatim: "–")
					Picker(selection: $viewModel.scheduleEnd) {
						ForEach(1...24, id: \.self) {
							Text(verbatim: "\($0):00")
						}
					} label: {
						EmptyView()
					}
					.frame(width: 96)
				}
				.pickerStyle(MenuPickerStyle())
			}
		}
		.frame(maxHeight: .infinity, alignment: .top)
		.padding()
		.frame(idealWidth: 400)
	}
}

#Preview {
	let viewModel = FiltersViewModel()
	viewModel.jobs = PreviewData.sampleJobs
	return FiltersView(viewModel: viewModel)
}
