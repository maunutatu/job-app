import SwiftUI

struct JobList<ViewModel: JobsViewModelProtocol>: View {
	@ObservedObject private var viewModel: ViewModel

	init(viewModel: ViewModel) {
		self.viewModel = viewModel
	}

	var body: some View {
		switch viewModel.state {
			case .loading:
				ProgressView()
			case .success(let jobs):
				content(jobs: jobs)
			case .error(let message):
				ErrorView(message: message)
		}
	}

	@ViewBuilder
	func content(jobs: [Job]) -> some View {
		List(jobs) { job in
			JobListRow(job: job)
				.background(
					RoundedRectangle(cornerRadius: 12)
						.foregroundStyle(.background)
						.shadow(color: .gray, radius: 1)
				)
				.listRowSeparator(.hidden)
		}.listStyle(.plain)
	}
}

#Preview {
	JobList(viewModel: JobsViewModelPreview())
}
