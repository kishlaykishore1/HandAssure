//
//  FaqModel.swift
//  HandAssure
//
//  Created by kishlay kishore on 09/11/20.
//

import Foundation

// MARK: - FAQDataModelElement
struct FAQDataModelElement: Codable {
    let id, position, question, answer: String
    let type, createdOn, updatedOn: String
    var isExpanded: Bool = false

    enum CodingKeys: String, CodingKey {
        case id, position, question, answer, type
        case createdOn = "created_on"
        case updatedOn = "updated_on"
    }
}
