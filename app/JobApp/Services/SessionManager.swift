import Combine

@MainActor
protocol SessionManagerProtocol: ObservableObject {
	var user: User? { get set }
}

class SessionManager: SessionManagerProtocol {
	var user: User?
}
