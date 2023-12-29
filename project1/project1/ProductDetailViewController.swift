//
//  ProductDetailViewController.swift
//  project1
//
//  Created by Ruchita Iyer on 12/6/23.
//

import UIKit
import FirebaseStorage

class ProductDetailViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var priceLabel: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var backButton: UIBarButtonItem!
    
    @IBOutlet weak var pickUpButton: UIButton!
    
    var products: Product?
    let storageRef = Storage.storage().reference()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.modalPresentationStyle = .fullScreen 
        
        Utilities.styleFilledButton(pickUpButton)
        
        // Do any additional setup after loading the view.
        if let product = products {
            titleLabel.text = "\(product.title)"
            priceLabel.text = "$\(product.price)"
            descriptionLabel.text = "\(product.description)"
            addressLabel.text = "\(product.address)"
            print(product.imageURL)
            let imageURL = product.imageURL // Assign product.imageURL directly to imageURL
            print("Image URL: \(imageURL)") // Print the imageURL before downloading the image
            
            downloadImage(from: imageURL)
            
        }
    }
    
    func downloadImage(from imageURL: String) {
        print("Image URL: \(imageURL)")
        let imageURL = "images/"+(extractFilename(from: imageURL) ?? "images/20C8E7DE-10C7-4E6E-9E54-B9E37053F39F.jpg")
        // Create a reference to the Firebase Storage object using the relative path
        print("Image URL: \(imageURL)")
        let imageRef = storageRef.child(imageURL)
        
        imageRef.getData(maxSize: 1 * 1024 * 1024) { [weak self] data, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Failed to download image with error: \(error)")
                return
            }
            
            guard let imageData = data else {
                print("No image data returned from Firebase")
                return
            }
            
            print("Image data size: \(imageData.count) bytes")
            
            guard let image = UIImage(data: imageData) else {
                print("Unable to initialize UIImage from data")
                return
            }
            
            DispatchQueue.main.async {
                self.imageView.image = image
                // Note: The reloadInputViews() call might not be necessary
            }
        }
    }
    
    func removeQueryString(from inputString: String) -> String {
        if let firstPart = inputString.components(separatedBy: "?").first {
            return firstPart
        } else {
            return inputString
        }
    }
    
    func extractFilename(from urlString: String) -> String? {
        // Create a URL from the provided string
        if let url = URL(string: urlString) {
            // Get the last path component of the URL, which is the filename
            let filename = url.lastPathComponent
            
            // Print or return the extracted filename
            print("Extracted Filename: \(filename)")
            return filename
        } else {
            print("Invalid URL")
            return nil
        }
    }
    
    
    @IBAction func pickUpTapped(_ sender: Any) {
        if let product = products {
            // Instantiate the ProductConfirmViewController
            if let productConfirmVC = storyboard?.instantiateViewController(withIdentifier: "ProductConfirmViewController") as? ProductConfirmViewController {
                // Pass product details to the ProductConfirmViewController
                productConfirmVC.confirmedTitle = product.title
                productConfirmVC.confirmedPrice = "\(product.price)"
                // Pass any other necessary details
                productConfirmVC.confirmedDescription = product.description
                
                // Push the ProductConfirmViewController
                //                    navigationController?.pushViewController(productConfirmVC, animated: true)
                self.present(productConfirmVC, animated: true, completion: nil)
            }
        }
    }
}
