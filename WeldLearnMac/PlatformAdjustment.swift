//
//  PlatformAdjustment.swift
//  WeldLearnMac
//
//  Created by JWSScott777 on 2/27/22.
//

import SwiftUI

typealias InsetGroupedListStyle = DefaultListStyle
typealias ImageButtonStyle = BorderlessButtonStyle
typealias MacOnlySpacer = Spacer

extension Notification.Name {
    static let willResignActive = NSApplication.willResignActiveNotification
}

extension Section where Parent: View, Content: View, Footer: View {
    func disableCollapsing() -> some View {
        self.collapsible(false)
    }
}
extension View {
    func macOnlyPadding() -> some View {
        self.padding()
    }
}

struct StackNavigationView<Content: View>: View {
    @ViewBuilder let content: () -> Content

    var body: some View {
        VStack(spacing: 0, content: content)

    }
}
