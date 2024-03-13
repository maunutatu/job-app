import SwiftUI

struct UserView<ViewModel: UserViewModelProtocol>: View {
	@ObservedObject private var viewModel: ViewModel

	@State var isLoginPresented = false
	@State var loginUserId = Int?.none

	@State var firstName: String = ""
	@State var lastName: String = ""
	@State var phoneNumber: String = ""
	@State var email: String = ""
	@State var dateOfBirth: Date = .now
	@State var experience: String = ""
	@State var education: String = ""
	@State var skills: [String] = []

	init(viewModel: ViewModel) {
		self.viewModel = viewModel
	}

	@FocusState private var focusedField: Field?

	enum Field: Hashable {
		case firstName, lastName, phoneNumber, email, dateOfBirth, experience, education, skill(index: Int)
	}

	var body: some View {
		container
			.alert(isPresented: .constant(viewModel.presentedError != nil), error: viewModel.presentedError) {
				Button("common.ok", role: .cancel) {
					viewModel.presentedError = nil
				}
			}
	}

	@ViewBuilder
	private var container: some View {
		NavigationStack {
			switch viewModel.state {
				case .loading:
					ProgressView()
				case .ready(let template):
					content
						.onChange(of: viewModel.state, initial: true) {
							setState(from: template)
						}
						.alert("user.login", isPresented: $isLoginPresented) {
							TextField("user.userId", value: $loginUserId, format: .number)
							Button("common.cancel", role: .cancel) {
								loginUserId = nil
							}
							Button("common.done", action: login)
						}
				case .error(let message):
					ErrorView(message: message)
			}
		}
	}

	private var content: some View {
		Form {
			if viewModel.userId == nil {
				VStack {
					Button("user.loginButton") {
						isLoginPresented = true
					}
					.padding(.bottom, 8)
					Text("user.loginSubtitle")
						.font(.footnote)
				}
				.frame(maxWidth: .infinity)
				.buttonStyle(BorderedProminentButtonStyle())
				.listRowBackground(EmptyView())
			}

			Section("user.personalInfoHeader") {
				VStack(alignment: .leading) {
					Text("user.firstName")
						.font(.headline)
					TextField("user.firstNamePlaceholder", text: $firstName)
						.focused($focusedField, equals: .firstName)
						.submitLabel(.next)
						.onSubmit {
							focusedField = .lastName
						}
				}

				VStack(alignment: .leading) {
					Text("user.lastName")
						.font(.headline)
					TextField("user.lastNamePlaceholder", text: $lastName)
						.focused($focusedField, equals: .lastName)
						.submitLabel(.next)
						.onSubmit {
							focusedField = .phoneNumber
						}
				}

				VStack(alignment: .leading) {
					Text("user.phoneNumber")
						.font(.headline)
					TextField("user.phoneNumberPlaceholder", text: $phoneNumber)
						.focused($focusedField, equals: .phoneNumber)
						.submitLabel(.next)
						.onSubmit {
							focusedField = .email
						}
						.modifier(KeyboardTypeModifier(keyboardType: .phonePad))
				}

				VStack(alignment: .leading) {
					Text("user.email")
						.font(.headline)
					TextField(String(localized: "user.emailPlaceholder"), text: $email)
						.focused($focusedField, equals: .email)
						.submitLabel(.next)
						.modifier(KeyboardTypeModifier(keyboardType: .emailAddress))
				}

				VStack(alignment: .leading) {
					Text("user.dateOfBirth")
						.font(.headline)
					DatePicker(selection: $dateOfBirth, in: ...Date(), displayedComponents: .date) {}
						.labelsHidden()
				}
			}

			Section("user.professionalDetailsHeader") {
				VStack(alignment: .leading) {
					Text("user.experience")
						.font(.headline)
					TextField("user.experiencePlaceholder", text: $experience)
						.focused($focusedField, equals: .experience)
						.submitLabel(.next)
						.onSubmit {
							focusedField = .education
						}
				}

				VStack(alignment: .leading) {
					Text("user.education")
						.font(.headline)
					TextField("user.educationPlaceholder", text: $education)
						.focused($focusedField, equals: .education)
						.submitLabel(.next)
						.onSubmit {
							guard let index = $skills.indices.first else { return }
							focusedField = .skill(index: index)
						}
				}

				VStack(alignment: .leading) {
					Text("user.skills")
						.font(.headline)
					ForEach($skills.indices, id: \.self) { index in
						TextField("user.skillPlaceholder", text: $skills[index])
							.focused($focusedField, equals: .skill(index: index))
							.submitLabel(.done)
						Divider()
					}
					Button("user.addSkill", systemImage: "plus", action: addSkill)
						.padding(4)
						.buttonStyle(BorderlessButtonStyle())
				}
			}

			VStack(spacing: 16) {
				HStack(spacing: 32) {
					if viewModel.userId != nil {
						Button("user.logoutButton", role: .destructive) {
							viewModel.logout()
						}
					}
					Button(action: save) {
						switch viewModel.saveButtonState {
							case .loading:
								ProgressView()
							case .ready:
								Text("user.saveButton")
							case .error(let message):
								Text(message)
						}
					}
				}
				if let userId = viewModel.userId {
					Text(String(format: String(localized: "user.logoutSubtitle"), userId))
					.font(.footnote)
				}
			}
			.frame(maxWidth: .infinity)
			.buttonStyle(BorderedProminentButtonStyle())
			.listRowBackground(EmptyView())
		}
	}

	private func addSkill() {
		skills.append("")
	}

	private func save() {
		let template = UserTemplate(
			firstName: firstName,
			lastName: lastName,
			phoneNumber: phoneNumber,
			email: email,
			dateOfBirth: dateOfBirth,
			experience: experience,
			education: education,
			skills: skills
		)
		viewModel.save(template: template)
	}

	private func login() {
		guard let loginUserId else { return }
		viewModel.login(withId: loginUserId)
		self.loginUserId = nil
	}

	private func setState(from template: UserTemplate) {
		firstName = template.firstName
		lastName = template.lastName
		phoneNumber = template.phoneNumber
		email = template.email
		dateOfBirth = template.dateOfBirth
		experience = template.experience
		education = template.education
		skills = template.skills
	}
}

struct UserView_Previews: PreviewProvider {
	static var previews: some View {
		UserView(viewModel: SampleUserViewModel(loggedIn: true))
	}
}
