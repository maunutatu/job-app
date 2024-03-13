import SwiftUI

@MainActor
struct JobView<ViewModel: JobViewModelProtocol>: View {
	struct Skill: Identifiable {
		var id: String { name }
		var name: String
		var isSelected: Bool
	}

	@ObservedObject private var viewModel: ViewModel

	@State private var coverLetter = ""
	@State private var skills: [Skill] = []

	init(viewModel: ViewModel) {
		self.viewModel = viewModel
	}

	var body: some View {
		ScrollView {
			VStack(alignment: .leading, spacing: 12) {
				header
				Divider()
				content
				Spacer()
				switch viewModel.state {
					case .notLoggedIn:
						nogLoggedIn
					case .loggedIn(let skills):
						application
							.onChange(of: viewModel.state, initial: true) {
								self.skills = skills.map { Skill(name: $0, isSelected: false) }
							}
					case .applicationSent:
						alreadyApplied
				}
			}
			.padding()
		}
		.scrollDismissesKeyboard(.interactively)
		.toolbar {
			URL(string: "https://example.com").map { ShareLink(item: $0) }
		}
		.alert(isPresented: .constant(viewModel.presentedError != nil), error: viewModel.presentedError) {
			Button("common.ok", role: .cancel) {
				viewModel.presentedError = nil
			}
		}
	}

	@ViewBuilder
	private var header: some View {
		VStack(alignment: .leading, spacing: 8) {
			Text(viewModel.job.title)
				.font(.headline)
			Text(viewModel.job.company + " • " + viewModel.job.location)
				.font(.subheadline)
		}
	}

	@ViewBuilder
	private var content: some View {
		VStack(alignment: .leading, spacing: 8) {
			Text(String(format: String(localized: "job.postedAt"), viewModel.job.datePosted.formatted(date: .abbreviated, time: .omitted)))
				.font(.footnote)
			Text(viewModel.job.employmentType + ", " + viewModel.job.workingHours)
				.font(.caption)
			Spacer()
			Text(viewModel.job.description)
		}
	}

	@ViewBuilder
	private var application: some View {
		VStack(alignment: .leading, spacing: 32) {
			VStack(alignment: .leading, spacing: 12) {
				Text("job.coverLetter")
					.font(.caption)
				TextEditor(text: $coverLetter)
					.frame(height: 200)
					.overlay(
						RoundedRectangle(cornerRadius: 4)
							.stroke(Color.gray, lineWidth: 0.5)
					)
			}

			VStack(alignment: .leading, spacing: 8) {
				Text("job.relevantSkillsTitle")
					.font(.caption)
				if skills.isEmpty {
					Text("job.noSkillsForUser")
				} else {
					ForEach($skills) { $skill in
						Toggle(isOn: $skill.isSelected) {
							Text(skill.name)
						}
					}
				}
			}

			Button(action: sendApplication) {
				Spacer()
				Text("job.applyButton")
				Spacer()
			}
			.buttonStyle(BorderedProminentButtonStyle())
			.controlSize(.large)
		}
	}

	@ViewBuilder
	private var nogLoggedIn: some View {
		VStack {
			Divider()
			Text("job.notLoggedIn")
				.padding()
		}
	}

	@ViewBuilder
	private var alreadyApplied: some View {
		VStack {
			Divider()
			Text("job.alreadyApplied")
				.padding()
		}
	}

	private func sendApplication() {
		let selectedSkills = skills.filter(\.isSelected).map(\.name)
		viewModel.sendApplication(coverLetter: coverLetter, relevantSkills: selectedSkills)
	}
}

#Preview {
	NavigationStack {
		JobView(viewModel: SampleJobViewModel(job: PreviewData.sampleJob))
	}
}
