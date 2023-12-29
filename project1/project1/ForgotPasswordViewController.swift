//
//  ForgotPasswordViewController.swift
//  project1
//
//  Created by Ruchita Iyer on 12/15/23.
//

import UIKit
import FirebaseAuth

class ForgotPasswordViewController: UIViewController {

    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    @IBAction func backAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func resetTapped(_ sender: UIButton) {
        guard let email = emailTextField.text, !email.isEmpty else {
                   // Handle empty email field
                   print("Please enter your email.")
                   return
               }
               
               Auth.auth().sendPasswordReset(withEmail: email) { [weak self] error in
                   guard let self = self else { return }
                   
                   if let error = error {
                       // Handle error sending reset password email
                       print("Error sending password reset email: \(error.localizedDescription)")
                       // You can show an alert or update the UI to notify the user
                   } else {
                       // Password reset email sent successfully
                       print("Password reset email sent to: \(email)")
                       // You can show an alert or update the UI to notify the user
                       self.showPasswordResetSentAlert()
                   }
               }
    }
    
    func showPasswordResetSentAlert() {
            let alertController = UIAlertController(
                title: "Password Reset Email Sent",
                message: "Please check your email for instructions to reset your password.",
                preferredStyle: .alert
            )
            let okAction = UIAlertAction(title: "OK", style: .default) { _ in
                // Handle the OK action if needed
            }
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        }

}
