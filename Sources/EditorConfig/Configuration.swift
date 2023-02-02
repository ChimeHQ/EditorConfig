import Foundation

public struct Configuration {
	public var indentStyle: IndentStyle?
	public var indentSize: Int?
	public var tabWidth: Int?
	public var charset: Charset?
	public var trimTrailingWhitespace: Bool?
	public var insertFinalNewline: Bool?
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

public struct ConfigurationSection {
	public let pattern: String
	public let configuration: Configuration
}
