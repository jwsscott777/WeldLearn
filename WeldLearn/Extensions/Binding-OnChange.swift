//
//  Binding-OnChange.swift
//  WeldLearn
//
//  Created by JWSScott777 on 1/9/21.
//

import SwiftUI

import SwiftUI

extension Binding {
    func onChange(_ handler: @escaping () -> Void) -> Binding<Value> {
        Binding(
            get: { self.wrappedValue },
            set: { newValue in
                self.wrappedValue = newValue
                handler()
            }
        )
    }
}
