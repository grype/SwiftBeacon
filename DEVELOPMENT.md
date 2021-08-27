# Development

## Building

Use Xcode to build. There's also a Makefile that collects various build and test tasks.

## Testing

Use [Swift Mock Generator For Xcode](https://github.com/seanhenry/SwiftMockGeneratorForXcode) to help with generating mocks.

When writing new classes that need to be mocked for testing, include `@available(*, message: "mocked")` in that file and run `make mocks`.
