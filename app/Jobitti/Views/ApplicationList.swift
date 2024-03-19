import SwiftUI

struct ApplicationList<ViewModel: ApplicationsViewModelProtocol>: View {
	@ObservedObject private var viewModel: ViewModel
	@State private var selectedApplication: JobApplication?

	init(viewModel: ViewModel) {
		self.viewModel = viewModel
	}

	var body: some View {
		switch viewModel.state {
			case .notLoggedIn:
				VStack {
					Text("applications.notLoggedIn")
						.padding()
				}
			case .ready(let applications):
				NavigationSplitView(
					sidebar: { sidebar(applications: applications) },
					detail: { detail }
				)
		}
	}

	@ViewBuilder
	private func sidebar(applications: [JobApplication]) -> some View {
		Group {
			if applications.isEmpty {
				Text("applications.noApplications")
			} else {
				applicationList(applications: applications)
			}
		}
		.navigationTitle("applications.title")
	}

	@ViewBuilder
	private func applicationList(applications: [JobApplication]) -> some View {
		List(applications, selection: $selectedApplication, rowContent: row)
			.listStyle(.plain)
	}

	@ViewBuilder
	func row(for application: JobApplication) -> some View {
		ApplicationListRow(application: application)
			.background(
				RoundedRectangle(cornerRadius: 12)
					.foregroundStyle(.background)
					.shadow(color: .gray, radius: 1)
			)
			.onTapGesture {
				selectedApplication = application
			}
			.listRowSeparator(.hidden)
			.listRowBackground(Color.clear)
	}

	@ViewBuilder
	private var detail: some View {
		if let selectedApplication {
			NavigationStack {
				ApplicationView(application: selectedApplication)
			}
		} else {
			Text("applications.noneSelected")
		}
	}
}

#Preview {
	ApplicationList(viewModel: SampleApplicationsViewModel())
}
