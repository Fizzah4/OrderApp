//
//  MenuItemDetailViewController.swift
//  OrderApp
//
//  Created by Fizzah Jabeen on 9/28/23.
//

import UIKit

class MenuItemDetailViewController: UIViewController {
    
    
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var detailTextLabel: UILabel!
    @IBOutlet var addToOrderButton: UIButton!
    @IBOutlet var imageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addToOrderButton.layer.cornerRadius = 5.0
        
        updateUI()
    }
    
    var menuItems: MenuItem!
    
    @IBAction func addToOrderButtonTapped(_ sender: UIButton){
        
        UIView.animate(withDuration: 0.3)
        {
            self.addToOrderButton.transform =
            CGAffineTransform(scaleX: 3.0, y: 3.0)
            self.addToOrderButton.transform =
            CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
        
        MenuController.shared.order.menuItems.append(menuItems)
    }
    
    func updateUI() {
        titleLabel.text = menuItems.name
        priceLabel.text = String(format: "$%.2f", menuItems.price)
        detailTextLabel.text = menuItems.detailText
        MenuController.shared.fetchImage(url: menuItems.imageURL) {
            (image) in
            guard let image = image else {return}
            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }
    }
}

