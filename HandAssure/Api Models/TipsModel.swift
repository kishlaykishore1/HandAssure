//
//  TipsModel.swift
//  HandAssure
//
//  Created by kishlay kishore on 09/11/20.
//

import Foundation

// MARK: - TipsDataModelElement
struct TipsDataModelElement: Codable {
    let id, tip, position, createdOn: String
    let updatedOn: String
    var isExpanded: Bool = false

    enum CodingKeys: String, CodingKey {
        case id, tip, position
        case createdOn = "created_on"
        case updatedOn = "updated_on"
    }
}
