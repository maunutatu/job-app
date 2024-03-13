import SwiftUI

struct KeyboardTypeModifier: ViewModifier {
	enum KeyboardType {
		case `default`
		case asciiCapable
		case numbersAndPunctuation
		case URL
		case numberPad
		case phonePad
		case namePhonePad
		case emailAddress
		case decimalPad
		case twitter
		case webSearch
		case asciiCapableNumberPad

		#if canImport(UIKit)
		var uiKeyboardType: UIKeyboardType {
			switch self {
				case .default: return .default
				case .asciiCapable: return .asciiCapable
				case .numbersAndPunctuation: return .numbersAndPunctuation
				case .URL: return .URL
				case .numberPad: return .numberPad
				case .phonePad: return .phonePad
				case .namePhonePad: return .namePhonePad
				case .emailAddress: return .emailAddress
				case .decimalPad: return .decimalPad
				case .twitter: return .twitter
				case .webSearch: return .webSearch
				case .asciiCapableNumberPad: return .asciiCapableNumberPad
			}
		}
		#endif
	}

	let keyboardType: KeyboardType

	func body(content: Content) -> some View {
		#if !os(macOS) && !os(tvOS)
		content
			.keyboardType(keyboardType.uiKeyboardType)
		#else
		content
		#endif
	}
}
