//
//  MetaEntity.swift
//  SalesSparrow
//
//  Created by Mohit Charkha on 31/07/23.
//

import Foundation

/**
 A struct that represents the meta data of an entity.
 */
struct Meta: Codable {
    
    let next_page_payload: pagination?
    
    struct pagination: Codable {
        let pagination_identifier: String?
    }
}
