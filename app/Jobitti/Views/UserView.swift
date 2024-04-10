import SwiftUI

struct UserView<ViewModel: UserViewModelProtocol>: View {
	@ObservedObject private var viewModel: ViewModel

	@State var isLoginPresented = false
	@State var loginUsername = ""

	@State var username: String = ""
	@State var firstName: String = ""
	@State var lastName: String = ""
	@State var phoneNumber: String = ""
	@State var email: String = ""
	@State var dateOfBirth: Date = .now
	@State var experience: [String] = []
	@State var education: String = ""
	@State var skills: [String] = []

	init(viewModel: ViewModel) {
		self.viewModel = viewModel
	}

	@FocusState private var focusedField: Field?

	enum Field: Hashable {
		case username
		case firstName
		case lastName
		case phoneNumber
		case email
		case dateOfBirth
		case experience(index: Int)
		case education
		case skill(index: Int)
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
							TextField("user.loginPlaceholder", text: $loginUsername)
							Button("common.cancel", role: .cancel) {
								loginUsername = ""
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
			if viewModel.username == nil {
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
					Text("user.username")
						.font(.headline)
					TextField("user.usernamePlaceholder", text: $username)
						.focused($focusedField, equals: .username)
						.submitLabel(.next)
						.onSubmit {
							focusedField = .firstName
						}
						.textInputAutocapitalization(.never)
						.autocorrectionDisabled()
				}

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
						.textInputAutocapitalization(.never)
						.autocorrectionDisabled()
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
					ForEach($experience.indices, id: \.self) { index in
						HStack {
							TextField("user.experiencePlaceholder", text: $experience[index])
								.focused($focusedField, equals: .experience(index: index))
								.submitLabel(.next)
								.onSubmit {
									focusedField = .education
								}
							Button {
								removeExperience(index)
							} label: {
								Image(systemName: "trash.fill")
							}
							.buttonStyle(BorderlessButtonStyle())
						}
						.frame(minHeight: 32)
						Divider()
					}
					Button(action: addExperience) {
						Image(systemName: "plus")
						Text("user.addExperience")
					}
					.padding(4)
					.buttonStyle(BorderlessButtonStyle())
					.disabled(!experience.isEmpty && experience.last?.isEmpty == true)
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
						HStack {
							TextField("user.skillPlaceholder", text: $skills[index])
								.focused($focusedField, equals: .skill(index: index))
								.submitLabel(.done)
							Button {
								removeSkill(index)
							} label: {
								Image(systemName: "trash.fill")
							}
							.buttonStyle(BorderlessButtonStyle())
						}
						.frame(minHeight: 32)
						Divider()
					}
					Button(action: addSkill) {
						Image(systemName: "plus")
						Text("user.addSkill")
					}
					.padding(4)
					.buttonStyle(BorderlessButtonStyle())
					.disabled(!skills.isEmpty && skills.last?.isEmpty == true)
				}
			}

			VStack(spacing: 16) {
				HStack(spacing: 32) {
					if viewModel.username != nil {
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
				if let username = viewModel.username {
					Text(String(format: String(localized: "user.logoutSubtitle"), username))
						.font(.footnote)
				}
			}
			.frame(maxWidth: .infinity)
			.buttonStyle(BorderedProminentButtonStyle())
			.listRowBackground(EmptyView())
		}
		.scrollDismissesKeyboard(.immediately)
	}

	private func addExperience() {
		guard experience.last?.isEmpty != true else { return }
		experience.append("")
		focusedField = experience.indices.last.map { .experience(index: $0) }
	}

	private func removeExperience(_ index: Int) {
		experience.remove(at: index)
	}

	private func addSkill() {
		guard skills.last?.isEmpty != true else { return }
		skills.append("")
		focusedField = skills.indices.last.map { .skill(index: $0) }
	}

	private func removeSkill(_ index: Int) {
		skills.remove(at: index)
	}

	private func save() {
		skills = skills.filter { !$0.isEmpty }
		let template = UserTemplate(
			username: username,
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
		guard !loginUsername.isEmpty else { return }
		viewModel.login(withUsername: loginUsername)
		loginUsername = ""
	}

	private func setState(from template: UserTemplate) {
		username = template.username
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
