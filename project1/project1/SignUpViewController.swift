//
//  SignUpViewController.swift
//  project1
//
//  Created by Ruchita Iyer on 12/6/23.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestore

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var showPassword: UIButton!
    
    var emailAlreadyExists = false
    var shouldSegueToHome = true
    var isPasswordVisible = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        Utilities.styleTextField(firstNameTextField)
        Utilities.styleTextField(lastNameTextField)
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(signUpButton)
        let eyeIconImage = UIImage(systemName: "eye.slash.fill")
        showPassword.setImage(eyeIconImage, for: .normal)
        showPassword.tintColor = .black
        passwordTextField.autocorrectionType = .no

    }
    
//    @IBAction func backAction(_ sender: UIBarButtonItem) {
//        dismiss(animated: true, completion: nil)
//    }
    @IBAction func backAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func showPasswordTapped(_ sender: UIButton) {
        isPasswordVisible.toggle() // Toggle the flag
                
                if isPasswordVisible {
                    passwordTextField.isSecureTextEntry = false // Show the password
                    let eyeIconImage = UIImage(systemName: "eye")
                    showPassword.setImage(eyeIconImage, for: .normal)
                } else {
                    passwordTextField.isSecureTextEntry = true // Hide the password
                    let eyeIconImage = UIImage(systemName: "eye.slash.fill")
                    showPassword.setImage(eyeIconImage, for: .normal)
                }
    }
    
    func validateFields() -> String? {
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            showAlert(message: "Fields cannot be empty")
            return "Fields cannot be empty"
        }
        
        let cleanedPassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if Utilities.isPasswordValid(cleanedPassword) == false {
            showAlert(message: "Password must contain at least 8 characters, including a number and a special character.")
            return "Invalid password"
        }
        
        return nil
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBAction func signUpTapped(_ sender: UIButton) {
        //        let error = validateFields()
        //            if error != nil {
        //                // Handle validation error
        //            } else {
        //                let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        //                let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        //
        //                Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
        //                    guard let self = self else { return }
        //
        //                    if let error = error as NSError? {
        //                                        if error.code == AuthErrorCode.emailAlreadyInUse.rawValue {
        //                                            // Email is already in use
        //                                            print("Email already registered")
        //                                            self.shouldSegueToHome = false // Set flag to prevent segue
        //                                            DispatchQueue.main.async {
        //                                                // Show an error message to the user
        //                                                let alertController = UIAlertController(title: "Error", message: "Email already exists.", preferredStyle: .alert)
        //                                                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        //                                                alertController.addAction(okAction)
        //                                                self.present(alertController, animated: true, completion: nil)
        //                                            }
        //                        } else {
        //                            // Handle other errors
        //                            print("Error creating user: \(error.localizedDescription)")
        //                        }
        //                    } else {
        //                        // User created successfully
        //                        // Continue with storing user data in Firestore and segue to home
        //                        self.saveUserDataToFirestore()
        //                    }
        //                }
        //            }
        //        }
        //
        //        func saveUserDataToFirestore() {
        //            guard let currentUser = Auth.auth().currentUser else {
        //                print("No logged-in user found")
        //                return
        //            }
        //
        //            let db = Firestore.firestore()
        //            let userRef = db.collection("users").document(currentUser.uid)
        //
        //            let firstname = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        //            let lastname = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        //
        //            userRef.setData([
        //                "firstname": firstname,
        //                "lastname": lastname,
        //                "uid": currentUser.uid
        //            ]) { error in
        //                if let error = error {
        //                    // Handle Firestore data saving error
        //                    print("Error saving user data: \(error.localizedDescription)")
        //                } else {
        //                    // User data saved successfully, segue to home
        //                    if self.shouldSegueToHome {
        //                        // Check if the current view controller is still visible before performing the segue
        //                        if self.isViewLoaded && (self.view.window != nil) {
        //                            self.performSegue(withIdentifier: "HomeSegue", sender: self)
        //                        }
        //                    }
        //                }
        //            }
        //        }
        //
        //
        ////    func showError(_ message: String) {
        ////        errorLabel.text = message
        ////        errorLabel.alpha = 1
        ////    }
        //
        //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //        if emailAlreadyExists {
        //            // Don't perform segue if email exists
        //            return
        //          }
        //           if segue.identifier == "HomeSegue" {
        //               if let destinationVC = segue.destination as? HomeViewController {
        //                   // Pass user's name to the destination view controller
        //                   let name = "\(firstNameTextField.text!)"
        //                   destinationVC.userName = name
        //               }
        //           }
        //       }
        
        let error = validateFields()
        if error != nil {
            // Handle validation error
        } else {
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
                guard let self = self else { return }
                
                if let error = error as NSError? {
                    if error.code == AuthErrorCode.emailAlreadyInUse.rawValue {
                        // Email is already in use
                        print("Email already registered")
                        DispatchQueue.main.async {
                            // Show an error message to the user
                            let alertController = UIAlertController(title: "Error", message: "Email already exists.", preferredStyle: .alert)
                            let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                            alertController.addAction(okAction)
                            self.present(alertController, animated: true, completion: nil)
                        }
                    } else {
                        // Handle other errors
                        print("Error creating user: \(error.localizedDescription)")
                    }
                } else {
                    // User created successfully
                    // Continue with storing user data in Firestore
                    self.saveUserDataToFirestore()
                }
            }
        }
    }
    
    func saveUserDataToFirestore() {
        guard let currentUser = Auth.auth().currentUser else {
            print("No logged-in user found")
            return
        }
        
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(currentUser.uid)
        
        let firstname = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let lastname = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        userRef.setData([
            "firstname": firstname,
            "lastname": lastname,
            "uid": currentUser.uid
        ]) { error in
            if let error = error {
                // Handle Firestore data saving error
                print("Error saving user data: \(error.localizedDescription)")
            } else {
                // User data saved successfully
                // Check if the current view controller is still visible before performing the segue
                if self.isViewLoaded && (self.view.window != nil) {
                    // Navigate to the "RegisterViewController" only if email is unique
                    self.navigateToRegisterViewController(with: firstname)
                }
            }
        }
    }
    
    // ... (existing code)
    
    func navigateToRegisterViewController(with firstname: String) {        
        let homeViewController = (storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController)!
        homeViewController.firstname = firstname
        homeViewController.modalPresentationStyle = .overFullScreen
        self.present(homeViewController, animated: true, completion: nil)
    }
}
