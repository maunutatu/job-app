import SwiftUI

struct JobListRow: View {
	let job: Job

	var body: some View {
		VStack(alignment: .leading, spacing: 8) {
			Text(job.title)
				.font(.headline)
			Group {
				Text(job.company + " • " + job.location)
				Text(job.employmentType)
			}
			.font(.footnote)
			Divider()
			Text(job.description)
		}.padding()
	}
}

#Preview {
	JobListRow(job: PreviewData.sampleJob)
}
