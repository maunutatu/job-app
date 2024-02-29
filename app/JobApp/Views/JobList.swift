import SwiftUI

struct JobList<ViewModel: JobsViewModelProtocol>: View {
	@ObservedObject private var viewModel: ViewModel
	@State private var selectedJob: Job?
	@State private var filtersShown = false

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
		NavigationSplitView(
			columnVisibility: .constant(.all),
			sidebar: { sidebar(with: jobs) },
			detail: { detail }
		)
		.navigationSplitViewStyle(.balanced)
	}

	@ViewBuilder
	func row(for job: Job) -> some View {
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

	@ViewBuilder
	private func sidebar(with jobs: [Job]) -> some View {
		VStack {
			jobList(for: jobs)
		}
		.toolbar {
			Button {
				filtersShown = true
			} label: {
				Image(systemName: "line.3.horizontal.decrease.circle")
			}
			.popover(isPresented: $filtersShown) {
				ScrollView {
					FiltersView(viewModel: viewModel.filtersViewModel)
				}
				.scrollBounceBehavior(.basedOnSize)
			}
		}
	}

	@ViewBuilder
	private func jobList(for jobs: [Job]) -> some View {
		if jobs.isEmpty {
			NoResultsView()
		} else {
			List(jobs, id: \.id, selection: $selectedJob, rowContent: row)
				.listStyle(.plain)
				.animation(.default, value: jobs)
				.searchable(text: $viewModel.searchText)
		}
	}

	@ViewBuilder
	private var detail: some View {
		if let selectedJob {
			NavigationStack {
				JobView(job: selectedJob)
			}
		} else {
			Text("job.noneSelected")
		}
	}
}

#Preview {
	JobList(viewModel: JobsViewModelPreview())
}
