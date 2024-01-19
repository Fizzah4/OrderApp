//
//  OrderConfirmationViewController.swift
//  OrderApp
//
//  Created by Fizzah Jabeen on 10/3/23.
//

import UIKit

class OrderConfirmationViewController: UIViewController {
        
    @IBOutlet var timeRemainingLabel: UILabel!
    var minutes: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timeRemainingLabel.text = "Thank you for your order! Your wait time is approximately \(minutes!) minutes"
    }
    
    @IBAction func unwindToOrderList(segue: UIStoryboardSegue) {
        
        self.dismiss(animated: true, completion: nil)
        MenuController.shared.order.menuItems.removeAll()

    }
}
