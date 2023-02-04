import Foundation

public final class Resolver {
	enum Failure: Error {
		case unsupportedURL(URL)
	}

	let rootURL: URL?

	public init(rootURL: URL? = nil) {
		self.rootURL = rootURL
	}

	func effectiveRules(for url: URL) throws -> ConfigurationRules {
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

		return ConfigurationRules(root: true, sections: sections)
	}

	func configuration(for url: URL) throws -> Configuration {
		let rules = try effectiveRules(for: url)

		return rules.sections.first?.configuration ?? Configuration()
	}
}
