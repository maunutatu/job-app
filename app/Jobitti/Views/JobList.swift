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
		TabView {
			jobsTab(with: jobs)
				.tabItem {
					Image(systemName: "list.bullet.circle")
					Text("tab.jobs")
				}
			applicationsTab
				.tabItem {
					Image(systemName: "doc.circle")
					Text("tab.applications")
				}
			userTab
				.tabItem {
					Image(systemName: "person.crop.circle")
					Text("tab.user")
				}
		}
	}

	@ViewBuilder
	private func jobsTab(with jobs: [Job]) -> some View {
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
					.foregroundStyle(Color(selectedJob == job ? .mainListItemSelected : .mainListItem))
			)
			.onTapGesture {
				withAnimation(.easeInOut(duration: 0.05)) {
					selectedJob = job
				}
			}
			.listRowSeparator(.hidden)
			.listRowBackground(Color.clear)
	}

	@ViewBuilder
	private func sidebar(with jobs: [Job]) -> some View {
		VStack {
			jobList(for: jobs)
		}
		.searchable(text: $viewModel.searchText)
		.toolbar {
			Button {
				filtersShown = true
			} label: {
				Text(filterButtonTitle).bold()
			}
			.popover(isPresented: $filtersShown) {
				ScrollView {
					FiltersView(viewModel: viewModel.filtersViewModel)
				}
				.scrollBounceBehavior(.basedOnSize)
			}
		}
		.navigationTitle(GlobalConstant.appName)
	}

	@ViewBuilder
	private var applicationsTab: some View {
		ApplicationList(viewModel: viewModel.applicationsViewModel)
	}

	@ViewBuilder
	private var userTab: some View {
		UserView(viewModel: viewModel.userViewModel)
	}

	@ViewBuilder
	private func jobList(for jobs: [Job]) -> some View {
		if jobs.isEmpty {
			NoResultsView()
		} else {
			List(jobs, id: \.id, selection: $selectedJob, rowContent: row)
				.listStyle(.plain)
				.animation(.default, value: jobs)
		}
	}

	@ViewBuilder
	private var detail: some View {
		if let selectedJob {
			NavigationStack {
				JobView(viewModel: viewModel.jobViewModel(for: selectedJob))
			}
		} else {
			Text("job.noneSelected")
		}
	}

	private var filterButtonTitle: String {
		let title = String(localized: "job.filterButton")
		let activeFilterCount = viewModel.activeFilterCount
		return title + (activeFilterCount > 0 ? " (\(activeFilterCount))" : "")
	}
}

#Preview {
	JobList(viewModel: JobsViewModelPreview())
}
