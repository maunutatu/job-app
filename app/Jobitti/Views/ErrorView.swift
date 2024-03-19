import SwiftUI

struct ErrorView: View {
	let message: String

	var body: some View {
		GeometryReader { geometry in
			ScrollView {
				VStack(spacing: 16) {
					Text("error.title")
						.font(.title2)
					Text(message)
						.font(.caption)
						.foregroundStyle(.gray)
				}
				.padding()
				.frame(width: geometry.size.width)
				.frame(minHeight: geometry.size.height)
			}
			.scrollBounceBehavior(.basedOnSize)
		}
	}
}

#Preview {
	ErrorView(message: "A sample error message")
}
