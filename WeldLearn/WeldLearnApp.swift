//
//  WeldLearnApp.swift
//  WeldLearn
//
//  Created by JWSScott777 on 1/8/21.
//

import SwiftUI

@main
struct WeldLearnApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @StateObject var dataController: DataController
    @StateObject var unlockManager: UnlockManager

    init() {
        let dataController = DataController()
        let unlockManager = UnlockManager(dataController: dataController)

        _dataController = StateObject(wrappedValue: dataController)
        _unlockManager = StateObject(wrappedValue: unlockManager)
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
                .environmentObject(dataController)
                .environmentObject(unlockManager)
                .onReceive(
                    NotificationCenter.default.publisher(
                        for: UIApplication.willResignActiveNotification), perform: save)
                .onAppear(perform: dataController.appLaunched)
        }
    }
    func save(_ note: Notification) {
        dataController.save()
    }
}
