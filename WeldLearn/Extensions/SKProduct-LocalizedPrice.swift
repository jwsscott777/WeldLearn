//
//  SKProduct-LocalizedPrice.swift
//  WeldLearn
//
//  Created by JWSScott777 on 4/9/21.
//

import StoreKit

extension SKProduct {
    var localizedPrice: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = priceLocale
        return formatter.string(from: price)!
    }
}
