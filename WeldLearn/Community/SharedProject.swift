//
//  SharedProject.swift
//  WeldLearn
//
//  Created by JWSScott777 on 7/18/21.
//

import Foundation

struct SharedProject: Identifiable {
    let id: String
    let title: String
    let detail: String
    let owner: String
    let closed: Bool

    static let example = SharedProject(id: "1", title: "Example", detail: "Detail", owner: "Semajttocs", closed: false)
}
