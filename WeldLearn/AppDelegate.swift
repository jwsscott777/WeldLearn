//
//  AppDelegate.swift
//  WeldLearn
//
//  Created by JWSScott777 on 4/20/21.
//

import SwiftUI

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions) ->
    UISceneConfiguration {
        let sceneConfiguration = UISceneConfiguration(
            name: "Default", sessionRole: connectingSceneSession.role)
        sceneConfiguration.delegateClass = SceneDelegate.self
        return sceneConfiguration
    }
}
