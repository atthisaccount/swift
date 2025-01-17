//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift.org open source project
//
// Copyright (c) 2014 - 2020 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
// See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//
//===----------------------------------------------------------------------===//

import ArgumentParser
import SwiftRemoteMirror


internal struct UniversalOptions: ParsableArguments {
  @Argument(help: "The pid or partial name of the target process")
  var nameOrPid: String
}

internal struct BacktraceOptions: ParsableArguments {
  @Flag(help: "Show the backtrace for each allocation")
  var backtrace: Bool = false

  @Flag(help: "Show a long-form backtrace for each allocation")
  var backtraceLong: Bool = false

  var style: BacktraceStyle? {
    if backtraceLong { return .long }
    if backtrace { return .oneLine }
    return nil
  }
}


internal func inspect<Process: RemoteProcess>(process pattern: String,
                                              _ body: (Process) throws -> Void) throws {
  guard let processId = process(matching: pattern) else {
    print("No process found matching \(pattern)")
    return
  }

#if os(iOS) || os(macOS) || os(tvOS) || os(watchOS)
  guard let process = DarwinRemoteProcess(processId: processId) else {
    print("Failed to create inspector for process id \(processId)")
    return
  }
#endif

  try body(process)
}

@main
internal struct SwiftInspect: ParsableCommand {
  static let configuration = CommandConfiguration(
    abstract: "Swift runtime debug tool",
    subcommands: [
      DumpConformanceCache.self,
      DumpRawMetadata.self,
      DumpGenericMetadata.self,
      DumpCacheNodes.self,
#if os(iOS) || os(macOS) || os(tvOS) || os(watchOS)
      DumpArrays.self,
      DumpConcurrency.self,
#endif
    ])
}
