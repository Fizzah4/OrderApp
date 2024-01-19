//
//  OrderTableViewController.swift
//  OrderApp
//
//  Created by Fizzah Jabeen on 9/28/23.
//

import UIKit

class OrderTableViewController: UITableViewController {
    
    var orderMinutes = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = editButtonItem
        
        NotificationCenter.default.addObserver(tableView as Any, selector: #selector(UITableView.reloadData), name: MenuController.orderUpdatedNotification, object: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MenuController.shared.order.menuItems.count
    }
    
    func configure(_ cell: UITableViewCell, forItemsAt indexPath: IndexPath) {
        
        let menuItem = MenuController.shared.order.menuItems[indexPath.row]
        cell.textLabel?.text = menuItem.name
        cell.detailTextLabel?.text = String(format: "$%.2f", menuItem.price)
        
        MenuController.shared.fetchImage(url: menuItem.imageURL){
            (image) in
            guard let image = image else {return}
            DispatchQueue.main.async{
                if let currentIndexPath = self.tableView.indexPath(for: cell),
                   currentIndexPath != indexPath{
                    return
                }
                cell.imageView?.image = image
                cell.setNeedsLayout()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Order", for: indexPath)
        configure(cell, forItemsAt: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool{
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
        if editingStyle == .delete {
            MenuController.shared.order.menuItems.remove(at: indexPath.row)
        }
    }
    
    
    @IBAction func unwindToOrderList(segue: UIStoryboardSegue){
        if segue.identifier == "DismissConfirmation" {
            MenuController.shared.order.menuItems.removeAll()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 100
    }
    
    func uploadOrder() {
        let menuIds = MenuController.shared.order.menuItems.map { $0.id }
        MenuController.shared.submitOrder(forMenuIDs: menuIds){
            (minutes) in
            DispatchQueue.main.async {
                if let minutes = minutes {
                    self.orderMinutes = minutes
                    self.performSegue(withIdentifier: "ConfirmationSegue", sender: nil)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ConfirmationSegue" {
            let orderConfirmationViewController = segue.destination
            as! OrderConfirmationViewController
            orderConfirmationViewController.minutes = orderMinutes
        }
    }
    
    @IBAction func submitTapped(_ sender: UIBarButtonItem){
        let orderTotal = MenuController.shared.order.menuItems.reduce(0.0)
        {
            (result, menuItem) -> Double in return result + menuItem.price
        }
        
        let formatteOrder = String(format: "$%.2f", orderTotal)
        let alertController = UIAlertController(title:
                                                    "Confirm Order", message: "You are about to submit your order with a total of \(formatteOrder)",
                                                preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Submit",
                                                style: .default, handler: { _ in
            self.uploadOrder()
        }))
        alertController.addAction(UIAlertAction(title: "Cancel",
                                                style: .cancel, handler: nil))
        
        present(alertController, animated: true, completion: nil)
        
    }
    
}

