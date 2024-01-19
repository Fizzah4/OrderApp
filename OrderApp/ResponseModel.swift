//
//  ResponseModel.swift
//  OrderApp
//
//  Created by Fizzah Jabeen on 9/29/23.
//

struct MenuResponse: Codable {
    let items: [MenuItem]
}

struct CategoryResponse: Codable {
    let categories: [String]        // array of strings
}

struct OrderResponse: Codable {
    let prepTime: Int
    
    enum CodingKeys: String, CodingKey{
        case prepTime = "preperation_time"
}

}

