//
//  ProductConfirmViewController.swift
//  project1
//
//  Created by Ruchita Iyer on 12/7/23.
//

import UIKit
import Firebase

class ProductConfirmViewController: UIViewController {
    
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var confirmButton: UIButton!
    
    
    var confirmedTitle: String = ""
    var confirmedPrice: String = ""
    var confirmedDescription: String = ""
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.modalPresentationStyle = .fullScreen
        // Do any additional setup after loading the view.
        Utilities.styleFilledButton(confirmButton)
        titleLabel.text = confirmedTitle
        priceLabel.text = confirmedPrice
        descriptionLabel.text = confirmedDescription
    }
    
    @IBAction func confirmButtonTapped(_ sender: UIButton) {
        let selectedDate = datePicker.date
        
        // Store confirmed purchase details in Firestore and update the product
        storeDataAndUpdateProduct(title: confirmedTitle, date: selectedDate)
        
        navigationController?.popToRootViewController(animated: true)
        
    }
    
    func storeDataAndUpdateProduct(title: String, date: Date) {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            print("User ID not found")
            return
        }
        
        // Update the product in Firestore with buyerID and selectedDate
        let productsCollection = db.collection("products")
        productsCollection.whereField("title", isEqualTo: title).getDocuments { [self] snapshot, error in
            if let error = error {
                print("Error updating product: \(error.localizedDescription)")
            } else {
                for document in snapshot!.documents {
                    document.reference.updateData([
                        "buyerID": currentUserID,
                        "selectedDate": date,
                        "availability": false // Update availability status
                        // Add other fields to update as needed
                    ])
                    print("Product updated successfully in Firestore")
                    showConfirmationAlert()
                }
            }
        }
    }
    
    func showConfirmationAlert() {
            let alertController = UIAlertController(
                title: "Product Confirmed",
                message: "Your product is confirmed for pickup.",
                preferredStyle: .alert
            )
            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        }
}
