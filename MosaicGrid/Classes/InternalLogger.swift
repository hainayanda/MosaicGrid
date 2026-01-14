//
//  InternalLogger.swift
//  MosaicGrid
//
//  Created by Nayanda Haberty on 1/2/24.
//

import Foundation
import os

private let logger: Logger = Logger()

func log(_ level: OSLogType, _ message: String, _ file: String = #file, _ function: String = #function, _ lineCount: Int = #line) {
    logger.log(level: level, "\(currentTimeStamp()) [MosaicGrid] \(function) at \(file) line \(lineCount): \(message)")
}

private let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd hh:mm:ss.SSS"
    return formatter
}()

private func currentTimeStamp() -> String {
    dateFormatter.string(from: Date())
}
