//
//  ViewController.swift
//  Consequatur
//
//  Created by Hwee Hong Chia on 2/17/25.
//

import UIKit

class InteractionViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var textView: UITextView!
    
    let myConsequatur = Consequatur.shared

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func sendInput(_ sender: UIButton) {
        guard let userText = textField.text, !userText.isEmpty else { return }
        let response = myConsequatur.oneInteraction(userText)
        textView.text.append("\nUser: \(userText)\nConsequatur: \(response)")
        textField.text = ""
    }

//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        textField.resignFirstResponder()
//        processInput()
//        return true
//    }

//    private func processInput() {
//        guard let userText = textField.text, !userText.isEmpty else { return }
//        let response = myConsequatur.oneInteraction(userText)
//        textView.text.append("\nUser: \(userText)\nConsequatur: \(response)")
//        textField.text = ""
//    }
}
