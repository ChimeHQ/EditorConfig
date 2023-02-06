[![Build Status][build status badge]][build status]
[![License][license badge]][license]
[![Platforms][platforms badge]][platforms]

# EditorConfig
A Swift library for working with [editorconfig][editorconfig] files

- Parse and resolve editorconfigf files
- Enforce a limitation on how far up the filesystem the resolution will scan
- Render `Configuration` structs back into the editorconfig format

As of right now, this library does not handle curly brace expansion inside patterns.

## Usage

```swift
import EditorConfig

let resolver = Resolver()

let fileURL = URL(fileURLWithPath: "path/to/myfile")

let configuration = try resolver.configuration(for: fileURL)
```

## Contributing and Collaboration

I prefer collaboration, and would love to find ways to work together if you have a similar project.

I prefer indentation with tabs for improved accessibility. But, I'd rather you use the system you want and make a PR than hesitate because of whitespace.

## Suggestions and Feedback

I'd love to hear from you! Get in touch via [mastodon](https://mastodon.social/@mattiem), an issue, or a pull request.

By participating in this project you agree to abide by the [Contributor Code of Conduct](CODE_OF_CONDUCT.md).

[editorconfig]: https://editorconfig.org
[build status]: https://github.com/ChimeHQ/EditorConfig/actions
[build status badge]: https://github.com/ChimeHQ/EditorConfig/workflows/CI/badge.svg
[license]: https://opensource.org/licenses/BSD-3-Clause
[license badge]: https://img.shields.io/github/license/ChimeHQ/EditorConfig
[platforms]: https://swiftpackageindex.com/ChimeHQ/EditorConfig
[platforms badge]: https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FChimeHQ%2FEditorConfig%2Fbadge%3Ftype%3Dplatforms
