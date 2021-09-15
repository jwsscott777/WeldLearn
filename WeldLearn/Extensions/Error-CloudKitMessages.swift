//
//  Error-CloudKitMessages.swift
//  Error-CloudKitMessages
//
//  Created by JWSScott777 on 9/14/21.
//
import CloudKit
import Foundation

extension Error {
    func getCloudKitError() -> CloudError {
        guard let error = self as? CKError else {
            return "An unknown error occured: \(self.localizedDescription)"
        }
        switch error.code {
        case .badContainer, .badDatabase, .invalidArguments:
                return "A fatal error occured: \(error.localizedDescription)"
        case .networkFailure, .networkUnavailable, .serviceUnavailable, .serverResponseLost:
                return "There was a problem communicating with iCloud; please check your connection"
        case .notAuthenticated:
                return "There was a problem with your account"
        case .requestRateLimited:
                return "You have hit the limit of iCloud requests"
        case .quotaExceeded:
                return "You have exceeded your iCloud quota limit, clear up some space"
        default:
                return "An unknown error occured: \(error.localizedDescription)"
        }
    }
}
