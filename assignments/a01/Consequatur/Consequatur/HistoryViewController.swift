//
//  HistoryViewController.swift
//  Consequatur
//
//  Created by Hwee Hong Chia on 2/28/25.
//

import UIKit

class HistoryViewController: UIViewController {

    @IBOutlet weak var historyTextView: UITextView!
    
    var historyText : [(String, String)] = []

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        updateHistory()
    }

    private func updateHistory() {

        let inputs = Consequatur.shared.getInputHistory()
        let outputs = Consequatur.shared.getOutputHistory()
        
        var total = ""
        for i in 0..<inputs.count {
            total += "\(inputs[i])\n\(outputs[i])\n"
            print(total)
        }
        historyTextView.text = total
        
//        let count = min(inputs.count, outputs.count)
//        historyText = (0..<count).map {(inputs[$0],outputs[$0])}
//        var historyString = ""
//        for (input, output) in historyText {
//            historyString += ("User: \(input)\nConsequatur: \(output)\n\n")
//        }
//        historyTextView.text += historyString
    }
}


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

