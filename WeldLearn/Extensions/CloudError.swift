//
//  CloudError.swift
//  CloudError
//
//  Created by JWSScott777 on 9/14/21.
//

import Foundation

struct CloudError: Identifiable, ExpressibleByStringInterpolation {
    var id: String { message }
    var message: String

    init(stringLiteral value: String) {
        self.message = value
    }
}
