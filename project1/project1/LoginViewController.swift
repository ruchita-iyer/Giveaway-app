//
//  LoginViewController.swift
//  project1
//
//  Created by Ruchita Iyer on 12/6/23.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseFirestoreInternal

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var showPassword: UIButton!
    
    var isSeguePerformed = false
    var userId: String?
    var isPasswordVisible = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.modalPresentationStyle = .fullScreen 
        Utilities.styleTextField(emailTextField)
        Utilities.styleTextField(passwordTextField)
        Utilities.styleFilledButton(loginButton)
        let eyeIconImage = UIImage(systemName: "eye.slash.fill")
        showPassword.setImage(eyeIconImage, for: .normal)
        showPassword.tintColor = .blue
    }
    
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
    
    @IBAction func loginTapped(_ sender: UIButton) {
        let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
//        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
//            guard let strongSelf = self else { return }
//            
//            if let error = error {
//                //                        strongSelf.showError("Login error: \(error.localizedDescription)")
//            } else {
//                strongSelf.fetchUserNameAndTransitionToHome()
//            }
//        }
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
                
                guard let strongSelf = self else { return }
                
                if let error = error {
                   // Wrong password
                   strongSelf.showAlert(message: "Invalid username or password")
                   return
                }
                
                strongSelf.fetchUserNameAndTransitionToHome()
                
            }
        
    }
    
    func showAlert(message: String) {
        
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    func fetchUserNameAndTransitionToHome() {
        guard let currentUser = Auth.auth().currentUser else {
            // No logged-in user found
            return
        }
        
        let db = Firestore.firestore()
        db.collection("users").document(currentUser.uid).getDocument { [weak self] (document, error) in
            guard let strongSelf = self else { return }
            
            if let document = document, document.exists {
                        let firstName = document.get("firstname") as? String ?? ""
                        strongSelf.transitionToHome(with: firstName)
                    } else {
                //                strongSelf.showError("User data not found")
            }
        }
    }
    
    func transitionToHome(with firstName: String) {        
        let homeViewController = (storyboard?.instantiateViewController(withIdentifier: "HomeViewController") as? HomeViewController)!
        homeViewController.firstname = firstName
        homeViewController.modalPresentationStyle = .overFullScreen
        self.present(homeViewController, animated: true, completion: nil)
        
    }
    
    @IBAction func forgotPassword(_ sender: UIButton) {
        self.transitionToForgotPassword()
    }
    
    func transitionToForgotPassword() {
        let forgotPasswordViewController = (storyboard?.instantiateViewController(withIdentifier: "ForgotPasswordViewController") as? ForgotPasswordViewController)!
//        homeViewController.firstname = firstName
        forgotPasswordViewController.modalPresentationStyle = .overFullScreen
        self.present(forgotPasswordViewController, animated: true, completion: nil)
    }
    
}

