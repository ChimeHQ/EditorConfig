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

	public mutating func apply(_ config: Configuration) {
		if let value = config.indentStyle {
			self.indentStyle = value
		}

		if let value = config.indentSize {
			self.indentSize = value
		}

		if let value = config.tabWidth {
			self.tabWidth = value
		}

		if let value = config.charset {
			self.charset = value
		}

		if let value = config.insertFinalNewline {
			self.insertFinalNewline = value
		}

		if let value = config.trimTrailingWhitespace {
			self.trimTrailingWhitespace = value
		}

		if let value = config.maxLineLength {
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

	public init(pattern: String, configuration: Configuration) {
		self.pattern = pattern
		self.configuration = configuration
	}

	public init(pattern: String, directives: [Directive]) {
		var config = Configuration()

		directives.forEach({ config.apply($0) })

		self.init(pattern: pattern, configuration: config)
	}
}

public struct ConfigurationFileContent: Hashable {
	public var root: Bool
	public var sections: [ConfigurationSection]

	public init(root: Bool = true, sections: [ConfigurationSection] = []) {
		self.root = root
		self.sections = sections
	}
}
