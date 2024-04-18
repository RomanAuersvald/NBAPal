//
//  OSLogExtension.swift
//  NBAPal
//
//  Created by Roman Auersvald on 18.04.2024.
//

import Foundation
import OSLog

extension Logger {
    private static var subsystem = Bundle.main.bundleIdentifier!
    static let navigation = Logger(subsystem: subsystem, category: "navigation")
    static let networking = Logger(subsystem: subsystem, category: "networking")
    static let userInteraction = Logger(subsystem: subsystem, category: "userInteraction")
}
