import SwiftUI

struct JobView: View {
	private let job: Job

	init(job: Job) {
		self.job = job
	}

	var body: some View {
		ScrollView {
			VStack(alignment: .leading, spacing: 12) {
				header
				Divider()
				content
				Spacer()
				footer
			}
			.padding()
		}
		.toolbar {
			URL(string: "https://example.com").map { ShareLink(item: $0) }
		}
	}

	@ViewBuilder
	private var header: some View {
		VStack(alignment: .leading, spacing: 8) {
			Text(job.title)
				.font(.headline)
			Text(job.company + " • " + job.location)
				.font(.subheadline)
		}
	}

	@ViewBuilder
	private var content: some View {
		VStack(alignment: .leading, spacing: 8) {
			Text(String(format: String(localized: "job.postedAt"), job.datePosted.formatted(date: .abbreviated, time: .omitted)))
				.font(.footnote)
			Text(job.employmentType)
				.font(.caption)
			Spacer()
			Text(job.description)
		}
	}

	@ViewBuilder
	private var footer: some View {
		NavigationLink(destination: JobApplicationView()) {
			Spacer()
			Text("job.applyButton")
			Spacer()
		}
		.buttonStyle(BorderedProminentButtonStyle())
		.controlSize(.large)
	}
}

#Preview {
	NavigationStack {
		JobView(job: PreviewData.sampleJob)
	}
}
