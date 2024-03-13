import SwiftUI

struct ApplicationView: View {
	private let application: JobApplication

	init(application: JobApplication) {
		self.application = application
	}

	var body: some View {
		ScrollView {
			HStack {
				VStack(alignment: .leading, spacing: 12) {
					VStack(alignment: .leading, spacing: 4) {
						Text(application.company)
							.font(.title)
						Text(application.jobTitle)
							.font(.headline)
					}
					Divider()
					VStack(alignment: .leading, spacing: 16) {
						Text(String(format: String(localized: "application.sentDate"), application.sentDate.formatted(date: .long, time: .omitted)))
							.font(.caption)
						VStack(alignment: .leading) {
							Text("application.coverLetter")
								.font(.caption)
							Text(application.coverLetter)
						}
						VStack(alignment: .leading) {
							Text("application.status")
								.font(.caption)
							Text("application.status.sent")
								.font(.headline)
								.foregroundStyle(.black)
								.padding(.horizontal, 8)
								.padding(.vertical, 4)
								.background(
									RoundedRectangle(cornerRadius: 2)
										.foregroundStyle(.yellow)
								)
						}
					}
				}
				Spacer()
			}
			.padding()
		}
	}
}
