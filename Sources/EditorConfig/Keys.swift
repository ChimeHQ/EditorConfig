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

public enum Directive {
	case root
	case indentStyle(IndentStyle)
	case indentSize(Int)
	case tabWidth(Int)
	case charset(Charset)
	case trimTrailingWhitespace(Bool)
	case insertFinalNewline(Bool)

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
		case .trimTrailingWhitespace(let value):
			return .pair(SupportedKeys.trimTrailingWhitespace.rawValue, value ? "true" : "false")
		case .insertFinalNewline(let value):
			return .pair(SupportedKeys.insertFinalNewline.rawValue, value ? "true" : "false")

		}
	}

	var string: String {
		statement.string
	}
}
