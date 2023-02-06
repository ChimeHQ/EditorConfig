import Foundation

enum SupportedKeys: String {
	case indentStyle = "indent_style"
	case indentSize = "indent_size"
	case tabWidth = "tab_width"
	case endOfLine = "end_of_line"
	case charset
	case trimTrailingWhitespace = "trim_trailing_whitespace"
	case insertFinalNewline = "insert_final_newline"
	case root
	case maxLineLength = "max_line_length"
}

public enum IndentStyle: String {
	case tab
	case space
}

public enum LineEnding: String {
	case lf
	case cr
	case crlf
}

public enum Charset: String {
	case latin1
	case utf8 = "utf-8"
	case utf8bom = "utf-8-bom"
	case utf16be = "utf-16be"
	case utf16le = "utf-16le"
}

public enum MaxLineLength: Hashable {
	case off
	case value(Int)
}

public enum Directive {
	case root
	case indentStyle(IndentStyle)
	case indentSize(Int)
	case tabWidth(Int)
	case charset(Charset)
	case endOfLine(LineEnding)
	case trimTrailingWhitespace(Bool)
	case insertFinalNewline(Bool)
	case maxLineLength(MaxLineLength)

	init?(_ keyString: String, _ valueString: String) {
		guard let key = SupportedKeys(rawValue: keyString) else { return nil }

		switch key {
		case .root:
			guard valueString == "true" else { return nil }

			self = .root
		case .indentStyle:
			guard let value = IndentStyle(rawValue: valueString) else { return nil }

			self = .indentStyle(value)
		case .indentSize:
			guard let value = Int(valueString) else { return nil }

			self = .indentSize(value)
		case .tabWidth:
			guard let value = Int(valueString) else { return nil }

			self = .tabWidth(value)
		case .charset:
			guard let value = Charset(rawValue: valueString) else { return nil }

			self = .charset(value)
		case .trimTrailingWhitespace:
			self = .trimTrailingWhitespace(valueString == "true")
		case .insertFinalNewline:
			self = .insertFinalNewline(valueString == "true")
		case .maxLineLength:
			if valueString == "off" {
				self = .maxLineLength(.off)
				return
			}

			guard let value = Int(valueString) else { return nil }

			self = .maxLineLength(.value(value))
		case .endOfLine:
			guard let value = LineEnding(rawValue: valueString) else { return nil }

			self = .endOfLine(value)
		}
	}

	var statement: Statement {
		switch self {
		case .root:
			return .pair(SupportedKeys.root.rawValue, "true")
		case .indentStyle(let style):
			return .pair(SupportedKeys.indentStyle.rawValue, style.rawValue)
		case .indentSize(let size):
			return .pair(SupportedKeys.indentSize.rawValue, "\(size)")
		case .tabWidth(let width):
			return .pair(SupportedKeys.tabWidth.rawValue, "\(width)")
		case .charset(let set):
			return .pair(SupportedKeys.charset.rawValue, set.rawValue)
		case .endOfLine(let ending):
			return .pair(SupportedKeys.endOfLine.rawValue, ending.rawValue)
		case .trimTrailingWhitespace(let value):
			return .pair(SupportedKeys.trimTrailingWhitespace.rawValue, value ? "true" : "false")
		case .insertFinalNewline(let value):
			return .pair(SupportedKeys.insertFinalNewline.rawValue, value ? "true" : "false")
		case .maxLineLength(.off):
			return .pair(SupportedKeys.maxLineLength.rawValue, "off")
		case .maxLineLength(.value(let value)):
			return .pair(SupportedKeys.maxLineLength.rawValue, "\(value)")
		}
	}

	var string: String {
		statement.string
	}
}
