import Foundation

public actor Resolver {
	func configuration(for url: URL) async throws -> Configuration {
		return Configuration()
	}
}
