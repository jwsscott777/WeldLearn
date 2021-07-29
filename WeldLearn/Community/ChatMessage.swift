//
//  ChatMessage.swift
//  ChatMessage
//
//  Created by JWSScott777 on 7/29/21.
//
import CloudKit
import Foundation

struct ChatMessage: Identifiable {
    let id: String
    let from: String
    let text: String
    let date: Date
}

extension ChatMessage {
    init(from record: CKRecord) {
        id = record.recordID.recordName
        from = record["from"] as? String ?? "No Author"
        text = record["text"] as? String ?? "No text"
        date = record.creationDate ?? Date()
    }
}
