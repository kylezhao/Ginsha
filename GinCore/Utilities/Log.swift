//
//  Log.swift
//  GinCore
//
//  Created by Kyle Zhao on 12/20/20.
//

import os.log

fileprivate let logCore = Logger.init(subsystem: "com.kyle.gin", category: "Core")
fileprivate let logApp = Logger.init(subsystem: "com.kyle.gin", category: "App")

public func logCore(_ message: String, file: NSString = #file, function: String = #function) {
    let trimmedPath = (file.lastPathComponent as NSString).deletingPathExtension
    logCore.info("\(trimmedPath):\(function) \(message)")
}

public func logCoreDebug(_ message: String, file: NSString = #file, function: String = #function) {
    let trimmedPath = (file.lastPathComponent as NSString).deletingPathExtension
    logCore.debug("\(trimmedPath):\(function) \(message)")
}

public func logCoreError(_ message: String, file: NSString = #file, function: String = #function) {
    let trimmedPath = (file.lastPathComponent as NSString).deletingPathExtension
    logCore.error("\(trimmedPath):\(function) \(message)")
}

public func logApp(_ message: String, file: NSString = #file, function: String = #function) {
    let trimmedPath = (file.lastPathComponent as NSString).deletingPathExtension
    logApp.info("\(trimmedPath):\(function) \(message)")
}

public func logAppDebug(_ message: String, file: NSString = #file, function: String = #function) {
    let trimmedPath = (file.lastPathComponent as NSString).deletingPathExtension
    logApp.debug("\(trimmedPath):\(function) \(message)")
}

public func logAppError(_ message: String, file: NSString = #file, function: String = #function) {
    let trimmedPath = (file.lastPathComponent as NSString).deletingPathExtension
    logApp.error("\(trimmedPath):\(function) \(message)")
}
