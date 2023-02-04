import Foundation

public struct Configuration: Hashable {
	public var indentStyle: IndentStyle?
	public var indentSize: Int?
	public var tabWidth: Int?
	public var charset: Charset?
	public var trimTrailingWhitespace: Bool?
	public var insertFinalNewline: Bool?
	public var maxLineLength: MaxLineLength?

	public init(indentStyle: IndentStyle? = nil,
				indentSize: Int? = nil,
				tabWidth: Int? = nil,
				charset: Charset? = nil,
				trimTrailingWhitespace: Bool? = nil,
				insertFinalNewline: Bool? = nil,
				maxLineLength: MaxLineLength? = nil) {
		self.indentStyle = indentStyle
		self.indentSize = indentSize
		self.tabWidth = tabWidth
		self.charset = charset
		self.trimTrailingWhitespace = trimTrailingWhitespace
		self.insertFinalNewline = insertFinalNewline
		self.maxLineLength = maxLineLength
	}

	public init(directives: [Directive]) {
		self.init()

		directives.forEach({ apply($0) })
	}

	public mutating func apply(_ directive: Directive) {
		switch directive {
		case .root:
			break
		case .tabWidth(let value):
			self.tabWidth = value
		case .charset(let value):
			self.charset = value
		case .indentSize(let value):
			self.indentSize = value
		case .indentStyle(let value):
			self.indentStyle = value
		case .insertFinalNewline(let value):
			self.insertFinalNewline = value
		case .trimTrailingWhitespace(let value):
			self.trimTrailingWhitespace = value
		case .maxLineLength(let value):
			self.maxLineLength = value
		}

	}
}

extension Configuration {
	public func render(root: Bool = true, headerPattern: String = "*") -> String {
		var lines = [String]()

		if root {
			lines.append(Directive.root.string + "\n")
		}

		lines.append(Statement.sectionHeader(headerPattern).string)

		if let value = indentStyle {
			lines.append(Directive.indentStyle(value).string)
		}

		if let value = indentSize {
			lines.append(Directive.indentSize(value).string)
		}

		if let value = tabWidth {
			lines.append(Directive.tabWidth(value).string)
		}

		if let value = charset {
			lines.append(Directive.charset(value).string)
		}

		if let value = trimTrailingWhitespace {
			lines.append(Directive.trimTrailingWhitespace(value).string)
		}

		if let value = insertFinalNewline {
			lines.append(Directive.insertFinalNewline(value).string)
		}

		return lines.joined(separator: "\n")
	}
}

public struct ConfigurationSection: Hashable {
	public var pattern: String
	public var configuration: Configuration
}

public struct ConfigurationRules: Hashable {
	public var root: Bool
	public var sections: [ConfigurationSection]

	public init(root: Bool = true, sections: [ConfigurationSection] = []) {
		self.root = root
		self.sections = sections
	}
}
