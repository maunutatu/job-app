import SwiftUI

struct JobList<ViewModel: JobsViewModelProtocol>: View {
	@ObservedObject private var viewModel: ViewModel
	@State private var selectedJob: Job?

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
		NavigationSplitView(columnVisibility: .constant(.all)) {
			List(jobs, id: \.id, selection: $selectedJob) { job in
				JobListRow(job: job)
					.background(
						RoundedRectangle(cornerRadius: 12)
							.foregroundStyle(.background)
							.shadow(color: .gray, radius: 1)
					)
					.onTapGesture {
						selectedJob = job
					}
					.listRowSeparator(.hidden)
					.listRowBackground(Color.clear)
			}
			.listStyle(.plain)
		} detail: {
			if let selectedJob {
				NavigationStack {
					JobView(job: selectedJob)
				}
			} else {
				Text("job.noneSelected")
			}
		}
		.navigationSplitViewStyle(.balanced)
	}
}

#Preview {
	JobList(viewModel: JobsViewModelPreview())
}
