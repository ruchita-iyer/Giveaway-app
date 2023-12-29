//
//  NewProductViewController.swift
//  project1
//
//  Created by Ruchita Iyer on 12/6/23.
//

import UIKit
import FirebaseFirestoreInternal
import FirebaseFirestore
import FirebaseStorage
import FirebaseAuth


class NewProductViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet weak var titleTextField: UITextField!
    
    @IBOutlet weak var priceTextField: UITextField!
    
    @IBOutlet weak var descriptionTextField: UITextField!
    
    @IBOutlet weak var addressTextField: UITextField!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var addImageButton: UIButton!
    
    @IBOutlet weak var submitButton: UIButton!
    
    let db = Firestore.firestore()
    let storage = Storage.storage()
    var selectedImage: UIImage?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.modalPresentationStyle = .fullScreen 
        Utilities.styleTextField(titleTextField)
        Utilities.styleTextField(priceTextField)
        Utilities.styleTextField(descriptionTextField)
        Utilities.styleTextField(addressTextField)
        Utilities.styleFilledButton(submitButton)
        Utilities.styleHollowButton(addImageButton)
    }
    
    @IBAction func backAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    @IBAction func addImageTapped(_ sender: UIButton) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        present(imagePickerController, animated: true, completion: nil)
    }
    
    @IBAction func submitTapped(_ sender: UIButton) {
        guard let title = titleTextField.text,
              let description = descriptionTextField.text,
              let priceTF = priceTextField.text,
              let price = Double(priceTF),
              let address = addressTextField.text,
              let image = selectedImage
        else {
            // Handle invalid or missing input
            return
        }
        let targetSizeInBytes = 500 * 1024
        if let compressedImage = compressImageToTargetSize(image, targetSizeInBytes: targetSizeInBytes) {
            // Use the compressedImage data as needed
            print("Compressed image size: \(compressedImage.count) bytes")
            
            let product = Product(title: title, description: description, price: price, address: address, imageURL: "")
            saveProductToFirestore(product, imageData: compressedImage)
        } else {
            print("Failed to compress image to the target size")
            // You can show an alert to the user indicating the failure to compress the image
        }
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = image
            selectedImage = image
        }
        dismiss(animated: true, completion: nil)
    }
    
    func saveProductToFirestore(_ product: Product, imageData: Data) {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            print("User ID not found")
            return
        }
        
        let imageRef = storage.reference().child("images/\(UUID().uuidString).jpg")
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        imageRef.putData(imageData, metadata: metadata) { [weak self] (metadata, error) in
            guard let self = self, let _ = metadata else {
                print("Error uploading image: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            
            imageRef.downloadURL { (url, error) in
                guard let imageURL = url?.absoluteString else {
                    print("Error getting image download URL: \(error?.localizedDescription ?? "Unknown error")")
                    return
                }
                
                let productData = [
                    "description": product.description,
                    "title": product.title,
                    "price": product.price,
                    "address": product.address,
                    "imageURL": imageURL,
                    "sellerID": currentUserID, // Link product to the seller
                    "availability": true
                    // Add other necessary fields here
                ] as [String : Any]
                
                let productsCollection = self.db.collection("products")
                let newProductRef = productsCollection.addDocument(data: productData) { error in
                    if let error = error {
                        print("Error adding product: \(error.localizedDescription)")
                        // Handle the error, if any
                    } else {
                        print("Product added successfully to Firestore")
                        // Handle success, such as showing an alert or navigating to another view
                        self.showProductAddedAlert()
                    }
                }
                newProductRef.updateData(["id": newProductRef.documentID]) // Add ID to the product
            }
        }
    }
    
    func showProductAddedAlert() {
        let alert = UIAlertController(title: "Success", message: "Product added successfully!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { _ in
            // Handle OK action if needed
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func compressImageToTargetSize(_ image: UIImage, targetSizeInBytes: Int) -> Data? {
        var compression: CGFloat = 1.0
        var imageData: Data?
        
        repeat {
            if let compressedData = image.jpegData(compressionQuality: compression) {
                imageData = compressedData
                compression -= 0.1
            } else {
                print("Failed to compress image")
                return nil
            }
        } while (imageData?.count ?? 0) > targetSizeInBytes && compression > 0.0
        
        return imageData
    }
    
}
