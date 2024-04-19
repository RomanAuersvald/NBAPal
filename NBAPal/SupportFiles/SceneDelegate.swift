//
//  SceneDelegate.swift
//  NBAPal
//
//  Created by Roman Auersvald on 15.04.2024.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var appCoordinator: AppCoordinator?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            let appCoordintor = AppCoordinator(window: window)
            appCoordintor.start()
            
            self.appCoordinator = appCoordintor
            window.makeKeyAndVisible()
        }
    }
}

