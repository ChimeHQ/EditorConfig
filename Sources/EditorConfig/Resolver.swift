import Foundation
import GlobPattern

public final class Resolver {
	enum Failure: Error {
		case unsupportedURL(URL)
		case noParentDirectories(URL)
	}

	let limitURL: URL?
	private var contentCache = [URL: ConfigurationFileContent]()

	public init(limitURL: URL? = nil) {
		self.limitURL = limitURL
	}

	private func parentDirectories(for url: URL) throws -> [URL] {
		guard url.isFileURL else {
			throw Failure.unsupportedURL(url)
		}
		
		var components = url.pathComponents

		var urls = [URL]()

		while components.isEmpty == false {
			components.removeLast()
			if components.isEmpty {
				break
			}
			
			let path = components.joined(separator: "/")

			let url = URL(fileURLWithPath: path, isDirectory: true)

			if url == limitURL {
				break
			}

			urls.append(url)
		}

		return urls
	}

	private func configContent(at url: URL) throws -> ConfigurationFileContent {
		let text = try String(contentsOf: url)
		return try Parser().parse(text)
	}

	public func configuration(for url: URL) throws -> Configuration {
		guard url.isFileURL else {
			throw Failure.unsupportedURL(url)
		}

		let urls = try parentDirectories(for: url)
		let pathComponents = url.pathComponents

		let possibleConfigURLs = urls.map { $0.appendingPathComponent(".editorconfig", isDirectory: false) }.reversed()

		var config = Configuration()

		for configURL in possibleConfigURLs {
			guard FileManager.default.isReadableFile(atPath: configURL.path) else { continue }

			let configComponentCount = configURL.pathComponents.count - 1
			let relativeComponents = pathComponents.suffix(from: configComponentCount)
			let relativePath = relativeComponents.joined(separator: "/")

			let content = try configContent(at: configURL)
			let effectiveSections = try content.sections.filter({ try matches(relativePath, pattern: $0.pattern) })

			effectiveSections.forEach({ config.apply($0.configuration) })
		}

		return config
	}

	func matches(_ name: String, pattern: String) throws -> Bool {
		let patternMatcher = try Glob.Pattern(pattern, mode: .editorconfig)

		return patternMatcher.match(name)
	}
}
