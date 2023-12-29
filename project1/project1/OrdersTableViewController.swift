//
//  OrdersTableViewController.swift
//  project1
//
//  Created by Ruchita Iyer on 12/11/23.
//

import UIKit
import Firebase

class OrdersTableViewController: UITableViewController {
    
    let db = Firestore.firestore()
    
    var buyerProducts: [Buyer] = [] // Custom Order model to represent your data
    var userID: String?
    var product: [Product] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        self.modalPresentationStyle = .fullScreen
        if let currentUser = Auth.auth().currentUser {
            userID = currentUser.uid
            fetchBuyerProducts()
            print("\(String(describing: userID))")
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
    
    func fetchBuyerProducts() {
        guard let userID = userID else {
            print("User ID is missing")
            return
        }
        
        // Fetch orders where buyerId matches the logged-in user's ID
        db.collection("products")
            .whereField("buyerID", isEqualTo: userID)
            .getDocuments { [weak self] (snapshot, error) in
                guard let self = self, let snapshot = snapshot else {
                    print("Error fetching products: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                self.buyerProducts.removeAll() // Clear the orders array before populating new data
                
                for document in snapshot.documents {
                    print("\(document.data())")
                    let data = document.data()
                    if let title = data["title"] as? String,
                       let description = data["description"] as? String,
                       let price = data["price"] as? Double,
                       let address = data["address"] as? String,
                       let imageURL = data["imageURL"] as? String,
                       
                        let selectedDate = data["selectedDate"] as? Timestamp {
                        let product = Product(title: title, description: description, price: price, address: address, imageURL: imageURL)
                        let buyer = Buyer(product: product, selectedDate: selectedDate.dateValue())
                        self.buyerProducts.append(buyer)
                    }
                }
                
                self.tableView.reloadData() // Reload the table view data after fetching
                print("Number of fetched orders: \(self.buyerProducts.count)")
            }
    }
    
    
    // MARK: - Table view data source
    
    //    override func numberOfSections(in tableView: UITableView) -> Int {
    //        // #warning Incomplete implementation, return the number of sections
    //        return 1
    //    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return buyerProducts.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BuyerProductCell", for: indexPath)
        let buyer = buyerProducts[indexPath.row]
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
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d, yyyy h:mm a"
        let formattedDate = dateFormatter.string(from: buyer.selectedDate)
        // Configure the cell with order details
        cell.textLabel?.text = "Title: \(buyer.product.title)\nPick up time: \(formattedDate)\nAddress: \(buyer.product.address)"
        
        
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
