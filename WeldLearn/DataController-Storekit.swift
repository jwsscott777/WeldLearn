//
//  DataController-Storekit.swift
//  WeldLearn
//
//  Created by JWSScott777 on 5/25/21.
//
import Foundation
import StoreKit

extension DataController {
    func appLaunched() {
        guard count(for: Project.fetchRequest()) >= 5 else { return }
        #if os(iOS)
        let allScenes = UIApplication.shared.connectedScenes
        let scene = allScenes.first { $0.activationState == .foregroundActive }

        if let windowScene = scene as? UIWindowScene {
            SKStoreReviewController.requestReview(in: windowScene)
       }
        #endif
    }
}

