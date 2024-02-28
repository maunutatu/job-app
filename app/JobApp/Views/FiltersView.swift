import SwiftUI
import Flow

struct FiltersView<ViewModel: FiltersViewModelProtocol>: View {
	@ObservedObject private var viewModel: ViewModel

	init(viewModel: ViewModel) {
		self.viewModel = viewModel
	}

	var body: some View {
		VStack(alignment: .leading, spacing: 32) {
			VStack(alignment: .leading) {
				Text("filters.location")
					.font(.headline)
				Divider()
				HFlow {
					ForEach(Array(viewModel.locations.enumerated()), id: \.offset) { index, location in
						Toggle(location.name, isOn: $viewModel.locations[index].isEnabled)
							.toggleStyle(.button)
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
