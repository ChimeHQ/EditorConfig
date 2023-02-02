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
		var directives = [Directive]()

		if let value = indentSize {
			directives.append(.indentSize(value))
		}

		if let value = tabWidth {
			directives.append(.tabWidth(value))
		}

		if let value = charset {
			directives.append(.charset(value))
		}

		if let value = trimTrailingWhitespace {
			directives.append(.trimTrailingWhitespace(value))
		}

		if let value = insertFinalNewline {
			directives.append(.insertFinalNewline(value))
		}


		var lines = [String]()

		if root {
			lines.append(Directive.root.string + "\n")
		}

		lines.append(Statement.sectionHeader(headerPattern).string)

		lines.append(contentsOf: directives.map({ $0.string }))

		return lines.joined(separator: "\n")
	}
}
