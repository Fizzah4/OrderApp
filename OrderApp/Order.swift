//
//  Order.swift
//  OrderApp
//
//  Created by Fizzah Jabeen on 9/29/23.
//

struct Order: Codable {
    var menuItems: [MenuItem]
    
    init(menuItems: [MenuItem] = []){
        self.menuItems = menuItems
    }
}
