import Foundation

public final class Resolver {
	enum Failure: Error {
		case unsupportedURL(URL)
	}

	let rootURL: URL?

	public init(rootURL: URL? = nil) {
		self.rootURL = rootURL
	}

	public func effectiveRules(for url: URL) throws -> ConfigurationFileContent {
		guard url.isFileURL else {
			throw Failure.unsupportedURL(url)
		}

		var components = url.pathComponents
		var sections = [ConfigurationSection]()

		while components.isEmpty == false {
			components.removeLast()

			let path = components.joined(separator: "/") + "/.editorconfig"

			let configURL = URL(fileURLWithPath: path, isDirectory: false)

			guard FileManager.default.isReadableFile(atPath: configURL.path) else { continue }

			let content = try String(contentsOf: configURL)

			let rules = try Parser().parse(content)

			sections.append(contentsOf: rules.sections)

			if rules.root {
				break
			}
		}

		return ConfigurationFileContent(root: true, sections: sections)
	}

	func configuration(for url: URL) throws -> Configuration {
		let rules = try effectiveRules(for: url)

		return rules.sections.first?.configuration ?? Configuration()
	}

	func matches(_ name: String, pattern: String) throws -> Bool {
		let value = name.withCString { nameCStr in
			pattern.withCString { patternCStr in
				fnmatch(patternCStr, nameCStr, 0)
			}
		}

		if value == 0 {
			return true
		}

		if value == FNM_NOMATCH {
			return false
		}

		// something else is wrong
		
		return false
	}
}
