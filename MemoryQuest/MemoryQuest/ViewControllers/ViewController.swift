//
//  ViewController.swift
//  MemoryQuest
//
//  Created by Nathan Lassiter on 4/27/24.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func playClicked(_ sender: Any) {
        
        performSegue(withIdentifier: "toGameVC", sender: nil)
    }
    

    @IBAction func leaderBoardClicked(_ sender: Any) {
        performSegue(withIdentifier: "toLeaderBoardVC", sender: nil)
    }
    
}

