import SwiftUI

struct AutocapitalizationModifier: ViewModifier {
	enum Autocapitalization {
		case never
		case words
		case sentences
		case characters

		#if canImport(UIKit)
		var iOSAutocapitalization: TextInputAutocapitalization {
			switch self {
				case .never: return .never
				case .words: return .words
				case .sentences: return .sentences
				case .characters: return .characters
			}
		}
		#endif
	}

	let autocapitalization: Autocapitalization

	func body(content: Content) -> some View {
		#if !os(macOS) && !os(tvOS)
		content
			.textInputAutocapitalization(autocapitalization.iOSAutocapitalization)
		#else
		content
		#endif
	}
}
