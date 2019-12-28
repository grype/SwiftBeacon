# Development

## Building

There's a Makefile that collects various build and test tasks

## Git

There's a pre-commit hook for git that. Install it with:

```bash
make install-git-hooks
```

Currently that just checks to see if XCTestManifests.swift may be out of sync, and prints out a warning...

## Testing

Use [Swift Mock Generator For Xcode](https://github.com/seanhenry/SwiftMockGeneratorForXcode) to help with generating mocks.
