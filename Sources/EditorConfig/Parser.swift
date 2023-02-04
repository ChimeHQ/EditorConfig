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

	public func parse(_ input: String) throws -> ConfigurationRules {
		let statements = try parseStatements(input)

		var rules = ConfigurationRules(root: false)

		var currentPattern: String? = nil
		var directives = [Directive]()

		for statement in statements {
			switch statement {
			case .pair(let key, let value):
				guard let directive = Directive(key, value) else { continue }

				if case .root = directive, directives.isEmpty && rules.sections.isEmpty {
					rules.root = true
					break
				}

				directives.append(directive)
			case .sectionHeader(let pattern):
				if let current = currentPattern {
					var config = Configuration()

					directives.forEach({ config.apply($0) })
					directives.removeAll()

					let section = ConfigurationSection(pattern: current, configuration: config)

					rules.sections.append(section)
				}

				currentPattern = pattern
			}
		}

		if let current = currentPattern {
			var config = Configuration()

			directives.forEach({ config.apply($0) })
			directives.removeAll()

			let section = ConfigurationSection(pattern: current, configuration: config)

			rules.sections.append(section)
		}

		return rules
	}
}
