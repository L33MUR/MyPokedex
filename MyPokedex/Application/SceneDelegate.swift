//
//  SceneDelegate.swift
//  MyPokedex
//
//  Created by Pedro  Rey Simons on 27/02/2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        #if DEBUG
        // Short-circuit starting app if running unit tests.
        let isUnitTesting = ProcessInfo.processInfo.environment["XCTestConfigurationFilePath"] != nil
        guard !isUnitTesting else { return }
        #endif
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        
        //App colors
        ThemeManager.applyTheme(theme: .darkTheme)

        //Config initial VIPER module, embeded in navigation controller
        let splashModule = SplashWireframe()
        let navController = UINavigationController()
        navController.setRootWireframe(splashModule)
        
        //Setup window
        window.rootViewController = navController
        window.makeKeyAndVisible()
        self.window = window
        
    }
}

