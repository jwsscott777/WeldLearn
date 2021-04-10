//
//  UnlockView.swift
//  WeldLearn
//
//  Created by JWSScott777 on 4/9/21.
//
import StoreKit
import SwiftUI

struct UnlockView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var unlockManager: UnlockManager
    var body: some View {
        VStack {
            switch unlockManager.requestState {
            case .loaded(let product):
                    ProductView(product: product)
            case .failed(_):
                    Text("Sorry, there was an error loading the store. Please try again later")
            case .loading:
                    ProgressView("Loading..")
            case .purchased:
                    Text("Thank you!")
            case .deferred:
                    Text("Thank you! Your request is pending approval, but you can still use the app in the meantime.")
            }
        }
        .padding()
        .onReceive(unlockManager.$requestState) { value in
            if case .purchased = value {
                dismiss()
            }
        }
    }

    func dismiss() {
        presentationMode.wrappedValue.dismiss()
    }
}
