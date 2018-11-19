import XCTest

extension HTTPClientTests {
    static let __allTests = [
        ("testCustomUserAgent", testCustomUserAgent),
        ("testEffectiveURL", testEffectiveURL),
        ("testFetchLargeFile", testFetchLargeFile),
        ("testGzippedResponse", testGzippedResponse),
        ("testResponseBody", testResponseBody),
        ("testSSLStatusCode", testSSLStatusCode),
        ("testStatusCode", testStatusCode),
    ]
}

extension cURLTests {
    static let __allTests = [
        ("testGetStatusCode", testGetStatusCode),
        ("testHeaderWriteFunction", testHeaderWriteFunction),
        ("testPostField", testPostField),
        ("testReadFunction", testReadFunction),
        ("testSetHeaderOption", testSetHeaderOption),
        ("testWriteFunction", testWriteFunction),
    ]
}

#if !os(macOS)
public func __allTests() -> [XCTestCaseEntry] {
    return [
        testCase(HTTPClientTests.__allTests),
        testCase(cURLTests.__allTests),
    ]
}
#endif
