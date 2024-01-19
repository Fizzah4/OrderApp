//
//  MenuController.swift
//  OrderApp
//
//  Created by Fizzah Jabeen on 9/29/23.
//

import Foundation
import UIKit

class MenuController {
    
    var OrderMunites = 0
    
    static let shared = MenuController()
    
    let baseURL = URL(string: "http://localhost:8080/")!
    
    func fetchCategories(completion: @escaping ([String]?) -> Void)
    {
        let categoryURL =
        baseURL.appendingPathComponent("categories")
        
        let task = URLSession.shared.dataTask(with: categoryURL)
        {
            (data, respose, error) in
            if let data = data,
               let jsonDictionary = try?
                JSONSerialization.jsonObject(with: data) as?
                [String: Any],
               let categories = jsonDictionary["categories"] as?
                [String] {
                completion(categories)
            }
            else {
                completion(nil)
            }
        }
        task.resume()
    }
    
    func fetchMenuItems(forCategory categoryName: String,
                        completion: @escaping ([MenuItem]?) -> Void) {
        
        let initialMenuURL = baseURL.appendingPathComponent("menu")
        var components = URLComponents(url: initialMenuURL,
        resolvingAgainstBaseURL: true)!
        components.queryItems = [URLQueryItem(name: "category",
                                               value:categoryName)]
        let menuURL = components.url!
        
        let task = URLSession.shared.dataTask(with: menuURL) 
        { (data, response, error) in
            let jsonDecoder = JSONDecoder()
            if let data = data,
               let menuItems = try? jsonDecoder.decode(MenuItems.self, from: data){
                completion(menuItems.items)
            } 
            else
            {
                completion(nil)
            }
        }
        task.resume()
    }
    
    func submitOrder(forMenuIDs menuIds: [Int],
                     completion: @escaping (Int?) -> Void) {
        let orderURL = baseURL.appendingPathComponent("order")
        
        var request = URLRequest(url: orderURL)
        
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let data: [String: [Int]] = ["menuIds": menuIds]
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(data)
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request)
        {
            (data, respose, error) in
            if let data = data,
               let jsonDictionary = try?
                JSONSerialization.jsonObject(with: data) as?
                [String: Any],
               let prepTime = jsonDictionary ["preparation_time"] as? Int {
                completion(prepTime)
            }
            else{
                completion(nil)
            }
        }
        task.resume()
    }
    
    static let orderUpdatedNotification =
    Notification.Name("MenuController.orderUpdated")
    
    var order = Order() {
        didSet {
            NotificationCenter.default.post(name: MenuController.orderUpdatedNotification, object: nil)
        }
    }
    
    func fetchImage(url: URL, completion: @escaping (UIImage?) -> Void) {
        let task = URLSession.shared.dataTask(with: url){
            (data, response, error) in
            if let data = data,
               let image = UIImage(data: data) {
                completion(image)
            }
            else {
                completion(nil)
            }
        }
        task.resume()
    }
    
    func loadOrder() {
        let documentsDirectoryURL =
        FileManager.default.urls(for: .documentDirectory, 
                                 in: .userDomainMask).first!
        
        let orderFileURL =
        documentsDirectoryURL.appendingPathComponent("order").appendingPathExtension("json")
        
        guard let data = try? Data(contentsOf: orderFileURL)  else
        {return}
        
        order = (try? JSONDecoder().decode(Order.self, from: data)) ?? Order(menuItems: [])
    }
    
    func saveOrder() {
        let documentsDirectoryURL =
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let orderFileURL =
        documentsDirectoryURL.appendingPathComponent("order").appendingPathExtension("json")
        
        if let data = try? JSONEncoder().encode(order) {
            try? data.write(to: orderFileURL)
        }
    }
    
}
