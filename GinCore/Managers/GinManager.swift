//
//  GinManager.swift
//  GinCore
//
//  Created by Kyle Zhao on 12/20/20.
//

import Foundation

public class GinManager: DataManaging {

    public static let shared = GinManager()

    private let localManager: LocalManager = LocalManager()
    private let networkManager: NetworkManager = NetworkManager()

    // MARK: - DataManaging

    public func perform(command: Command) {
        networkManager.perform(command: command)
    }
}
