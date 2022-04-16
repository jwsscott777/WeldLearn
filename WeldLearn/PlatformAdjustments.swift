//
//  PlatformAdjustments.swift
//  WeldLearn
//
//  Created by JWSScott777 on 2/27/22.
//

import SwiftUI

typealias ImageButtonStyle = BorderlessButtonStyle
typealias MacOnlySpacer = EmptyView

extension Notification.Name {
    static let willResignActive = UIApplication.willResignActiveNotification
}

extension Section where Parent: View, Content: View, Footer: View {
    func disableCollapsing() -> some View {
        self
    }
}
extension View {
    func onDeleteCommand(perform action: (() -> Void)?) -> some View {
        self
    }
    func macOnlyPadding() -> some View {
        self
    }
}

struct StackNavigationView<Content: View>: View {
    @ViewBuilder let content: () -> Content

    var body: some View {
        NavigationView(content: content)
            .navigationViewStyle(.stack)
    }
}
