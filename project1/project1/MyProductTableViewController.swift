//
//  MyProductTableViewController.swift
//  project1
//
//  Created by Ruchita Iyer on 12/10/23.
//

import UIKit
import Firebase

class MyProductTableViewController: UITableViewController {
    
    var userID: String?
    var product: [Product] = []
    var sellerProducts: [ProductAvailability] = []
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.modalPresentationStyle = .fullScreen
        if let currentUser = Auth.auth().currentUser {
            userID = currentUser.uid // Assign the user ID
            fetchSellerProducts() // Fetch products after user ID is set
        } else {
            print("No authenticated user found")
            // Handle the case where no user is logged in
        }
        configureTableView()
    }
    
    func configureTableView() {
        //            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ProductCell")
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        //            tableView.backgroundColor = UIColor.groupTableViewBackground
    }
    
    func fetchSellerProducts() {
        guard let userID = userID else {
            print("User ID is missing")
            return
        }
        
        db.collection("products")
            .whereField("sellerID", isEqualTo: userID)
            .getDocuments { [weak self] (snapshot, error) in
                guard let self = self, let snapshot = snapshot else {
                    print("Error fetching products: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                
                self.sellerProducts.removeAll()
                
                for document in snapshot.documents {
                    let data = document.data()
                    // Parse data and create Product objects
                    if let title = data["title"] as? String,
                       let description = data["description"] as? String,
                       let price = data["price"] as? Double,
                       let address = data["address"] as? String,
                       let imageURL = data["imageURL"] as? String,
                       let availability = data["availability"] as? Bool {
                        let product = Product(title: title, description: description, price: price, address: address, imageURL: imageURL)
                        let productAvailability = ProductAvailability(product: product, availability: availability)
                        self.sellerProducts.append(productAvailability)
                    }
                }
                
                // Reload table view once products are fetched
                self.tableView.reloadData()
            }
    }
    
    
    
    // MARK: - Table view data source
    
    //    override func numberOfSections(in tableView: UITableView) -> Int {
    //        // #warning Incomplete implementation, return the number of sections
    //        return 0
    //    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return sellerProducts.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SellerProductCell", for: indexPath)
        
        let productAvailability = sellerProducts[indexPath.row]
        
        
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = .byWordWrapping
        cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
        cell.textLabel?.textColor = UIColor.black
        
        
        // Apply different background colors to alternate rows
        cell.contentView.backgroundColor = indexPath.row % 2 == 0 ? UIColor.white : UIColor.systemBlue.withAlphaComponent(0.1)
        
        // Add a border to the cell
        cell.layer.borderWidth = 1.0
        cell.layer.cornerRadius = 8.0
        //                cell.layer.borderColor = UIColor.green.cgColor
        cell.layer.borderColor = UIColor.init(red: 48/255, green: 99/255, blue: 173/255, alpha: 1).cgColor
        if productAvailability.availability {
            cell.textLabel?.text = "Title: \(productAvailability.product.title)\nAvailable"
        }
        else {
            cell.textLabel?.text = "Title: \(productAvailability.product.title)\nSold"
        }
        return cell
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }    
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
