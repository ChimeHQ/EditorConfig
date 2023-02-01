import Foundation

public enum Statement {
	case sectionHeader(String)
	case pair(String, String)
}

extension Statement: Hashable {
}

public struct Parser {
	func parse(_ input: String) throws -> [Statement] {
		let lines = input.split(whereSeparator: \.isNewline)

		return lines.compactMap { line -> Statement? in
			switch line.first {
			case "#", ";":
				return nil
			case "[":
				return .sectionHeader("something")
			default:
				break
			}

			let trimmedLine = line.trimmingCharacters(in: .whitespaces)
			if trimmedLine.isEmpty {
				return nil
			}

			let components = trimmedLine.split(separator: "=", maxSplits: 2)
			if components.count != 2 {
				return nil
			}

			let key = components[0].trimmingCharacters(in: .whitespaces)
			let value = components[1].trimmingCharacters(in: .whitespaces)

			return .pair(key, value)
		}
	}
}
