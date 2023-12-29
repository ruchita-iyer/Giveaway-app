//
//  ViewController.swift
//  project1
//
//  Created by Ruchita Iyer on 12/6/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
//        view.backgroundColor = .red
        Utilities.styleFilledButton(signUpButton)
        Utilities.styleHollowButton(loginButton)
    }

    @IBAction func signUpTapped(_ sender: Any) {
//        if let signUpViewController = storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController {
//                    // Optionally, you can customize the presentation style (e.g., push, modal, etc.)
//                    navigationController?.pushViewController(signUpViewController, animated: true)
//                }
        let signUpViewController = (storyboard?.instantiateViewController(withIdentifier: "SignUpViewController") as? SignUpViewController)!
        signUpViewController.modalPresentationStyle = .overFullScreen
        self.present(signUpViewController, animated: true, completion: nil)
    }
    
    @IBAction func loginTapped(_ sender: Any) {
        
//        if let loginViewController = storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController {
//                    // Optionally, you can customize the presentation style (e.g., push, modal, etc.)
//                    navigationController?.pushViewController(loginViewController, animated: true)
//                }
        let loginViewController = (storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController)!
        loginViewController.modalPresentationStyle = .overFullScreen
        self.present(loginViewController, animated: true, completion: nil)

    }
}

