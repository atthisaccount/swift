// RUN: %target-typecheck-verify-swift -target arm64-apple-macosx10.15 -swift-version 5
// REQUIRES: concurrency

func testAsyncSequence<Seq: AsyncSequence>(_ seq: Seq) async throws where Seq.Element == Int {
   async let result: Int = seq.reduce(0) { $0 + $1 } // OK
   // expected-warning@-1{{immutable value 'result' was never used; consider replacing with '_' or removing it}}
}

func testAsyncSequence1<Seq: AsyncSequence>(_ seq: Seq) async throws where Seq.Element == Int {
   async let _: Int = seq.reduce(0) { $0 + $1 } // OK
}
