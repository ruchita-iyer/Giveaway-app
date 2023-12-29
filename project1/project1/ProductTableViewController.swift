//
//  ProductTableViewController.swift
//  project1
//
//  Created by Ruchita Iyer on 12/6/23.
//

import UIKit
import FirebaseFirestoreInternal
import FirebaseAuth

class ProductTableViewController: UITableViewController {
    
    var products = [Product]()
    let db = Firestore.firestore()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchProducts()
        self.modalPresentationStyle = .fullScreen
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        configureTableView()
    }
    
    func configureTableView() {
        //            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ProductCell")
        tableView.separatorStyle = .none
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        //            tableView.backgroundColor = UIColor.groupTableViewBackground
    }
    
    
    func fetchProducts() {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            // If there is no logged-in user, return or handle accordingly
            return
        }
        let productsCollection = db.collection("products")
        
        productsCollection.whereField("availability", isEqualTo: true)
//            .whereField("buyerId", isNotEqualTo: currentUserID)
            .getDocuments { [weak self] (querySnapshot, error) in
                if let error = error {
                    print("Error fetching products: \(error.localizedDescription)")
                    // Handle the error, if any
                } else {
                    self?.products.removeAll() // Clear the existing products
                    
                    for document in querySnapshot!.documents {
                        let data = document.data()
                        if let title = data["title"] as? String,
                           let description = data["description"] as? String,
                           let price = data["price"] as? Double,
                           let imageURL = data["imageURL"] as? String,
                           let address = data["address"] as? String {
                            let product = Product(title: title, description: description, price: price, address: address, imageURL: imageURL)
                            self?.products.append(product)
                        }
                    }
                    DispatchQueue.main.async {
                        self?.tableView.reloadData()
                    }
                    
                    print("Number of fetched products: \(self?.products.count ?? 0)") // Print the count of fetched products
                }
            }
    }
    
    
    // MARK: - Table view data source
    /*
     override func numberOfSections(in tableView: UITableView) -> Int {
     // #warning Incomplete implementation, return the number of sections
     return 0
     }
     */
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return products.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ProductCell", for: indexPath)
        let product = products[indexPath.row]
        
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = .byWordWrapping
        cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
        cell.textLabel?.textColor = UIColor.black
        cell.textLabel?.text = "Title: \(product.title)\nPrice: \(product.price)"
        
        // Apply different background colors to alternate rows
        cell.contentView.backgroundColor = indexPath.row % 2 == 0 ? UIColor.white : UIColor.systemBlue.withAlphaComponent(0.1)
        
        // Add a border to the cell
        cell.layer.borderWidth = 1.0
        cell.layer.cornerRadius = 8.0
        //                cell.layer.borderColor = UIColor.green.cgColor
        cell.layer.borderColor = UIColor.init(red: 48/255, green: 99/255, blue: 173/255, alpha: 1).cgColor
        cell.textLabel?.text = "Title: \(product.title)\nPrice: \(product.price)"
        
        // Configure the cell...
        
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
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
        if let productDetailViewController = segue.destination as? ProductDetailViewController,
           let indexPath = tableView.indexPathForSelectedRow
        {
            let selectedProduct = products[indexPath.row]
            productDetailViewController.products = selectedProduct
        }
        
        
    }
}
