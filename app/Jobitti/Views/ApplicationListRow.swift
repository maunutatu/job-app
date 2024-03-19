import SwiftUI

struct ApplicationListRow: View {
	private let application: JobApplication

	init(application: JobApplication) {
		self.application = application
	}

	var body: some View {
		HStack {
			VStack(alignment: .leading) {
				Text(application.company ?? "")
					.font(.headline)
				Text(application.jobTitle ?? "")
					.font(.subheadline)
				Text(String(format: String(localized: "application.sentDate"), application.sentDate.formatted(date: .long, time: .omitted)))
					.font(.footnote)
			}
			Spacer()
		}
		.padding()
		.frame(maxWidth: .infinity)
	}
}
