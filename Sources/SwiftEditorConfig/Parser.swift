import Foundation

public enum Statement {
	case sectionHeader(String)
	case pair(String, String)

	var string: String {
		switch self {
		case .sectionHeader(let value):
			return "[\(value)]"
		case .pair(let key, let value):
			return "\(key) = \(value)"
		}
	}
}

extension Statement: Hashable {
}

public struct Parser {
	func parseStatements(_ input: String) throws -> [Statement] {
		let lines = input.split(whereSeparator: \.isNewline)

		return lines.compactMap { line -> Statement? in
			let trimmedLine = line.trimmingCharacters(in: .whitespaces)

			// blank
			if trimmedLine.isEmpty {
				return nil
			}

			// comment
			if trimmedLine.hasPrefix("#") || trimmedLine.hasPrefix(";") {
				return nil
			}

			if trimmedLine.hasPrefix("[") && trimmedLine.hasSuffix("]") {
				let start = trimmedLine.index(after: trimmedLine.startIndex)
				let end = trimmedLine.index(before: trimmedLine.endIndex)

				let content = String(trimmedLine[start..<end])

				return .sectionHeader(content)
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

	public func parse(_ input: String) throws -> [ConfigurationSection] {
		return []
	}
}
