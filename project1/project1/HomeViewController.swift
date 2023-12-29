//
//  HomeViewController.swift
//  project1
//
//  Created by Ruchita Iyer on 12/6/23.
//

import UIKit
import FirebaseAuth

class HomeViewController: UIViewController {
 
    @IBOutlet weak var nameLabel: UILabel!
    var firstname: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.modalPresentationStyle = .fullScreen
        
        // Do any additional setup after loading the view.
        if let firstname = firstname {
                    nameLabel.text = "Welcome, \(firstname)" // Assuming nameLabel is the label outlet
                }
        
    }
    
    @IBAction func sellProductTapped(_ sender: Any) {
        let newProductViewController = (storyboard?.instantiateViewController(withIdentifier: "NewProductViewController") as? NewProductViewController)!
        newProductViewController.modalPresentationStyle = .overFullScreen
        self.present(newProductViewController, animated: true, completion: nil)
    }
    
    @IBAction func buyProductTapped(_ sender: Any) {
        let productTableViewController = (storyboard?.instantiateViewController(withIdentifier: "ProductTableViewController") as? ProductTableViewController)!
        productTableViewController.modalPresentationStyle = .overFullScreen
//        present(productTableViewController, animated: true, completion: nil)
        navigationController?.pushViewController(productTableViewController, animated: true)
        
    }
    @IBAction func myProductTapped(_ sender: Any) {
        let myProductTableViewController = (storyboard?.instantiateViewController(withIdentifier: "MyProductTableViewController") as? MyProductTableViewController)!
        myProductTableViewController.modalPresentationStyle = .overFullScreen
//        self.present(sellerViewController, animated: true, completion: nil)
        navigationController?.pushViewController(myProductTableViewController, animated: true)
    }
    @IBAction func myOrderTapped(_ sender: UIButton) {
        let ordersTableViewController = (storyboard?.instantiateViewController(withIdentifier: "OrdersTableViewController") as? OrdersTableViewController)!
        ordersTableViewController.modalPresentationStyle = .overFullScreen
//        self.present(sellerViewController, animated: true, completion: nil)
        navigationController?.pushViewController(ordersTableViewController, animated: true)
    }
    @IBAction func logoutTappped(_ sender: UIButton) {
        do {
                try Auth.auth().signOut()
                // Navigate back to the previous screen or perform any necessary actions after logout
                // For example, you might dismiss this view controller if it was presented modally
                dismiss(animated: true, completion: nil)
            } catch let signOutError as NSError {
                print("Error signing out: \(signOutError.localizedDescription)")
                // Handle the sign-out error, if needed
            }
    }
}
