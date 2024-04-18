//
//  AppCoordinator.swift
//  NBAPal
//
//  Created by Roman Auersvald on 15.04.2024.
//

import SwiftUI
import UIKit
import Combine

class AppCoordinator: Coordinator {
    
    let window: UIWindow
    
    var childCoordinators = [Coordinator]()
    
    init(window: UIWindow) {
        self.window = window
    }
    
    func start() {
        let mainCoordinator = PlayersCoordinator()
        mainCoordinator.start()
        self.childCoordinators = [mainCoordinator]
        self.window.rootViewController = mainCoordinator.rootViewController
    }
}
