//
//  LeaderBoardViewController.swift
//  MemoryQuest
//
//  Created by Nathan Lassiter on 4/27/24.
//

import UIKit
import CoreData

class LeaderBoardViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var scoreTable: UITableView!
    
    var highScores: [HighScoreEntry] = []
        
        struct HighScoreEntry {
            var score: Int64
            var date: Date
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            scoreTable.delegate = self
            scoreTable.dataSource = self
            getData()
        }
        
        func getData() {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let fetchRequest: NSFetchRequest<NSManagedObject> = NSFetchRequest(entityName: "HighScore")
            fetchRequest.sortDescriptors = [NSSortDescriptor(key: "score", ascending: false)]
            fetchRequest.fetchLimit = 10
            fetchRequest.returnsObjectsAsFaults = false
            
            do {
                let results = try context.fetch(fetchRequest) 
                highScores = results.map {
                    HighScoreEntry(score: $0.value(forKey: "score") as? Int64 ?? 0,
                                   date: $0.value(forKey: "date") as? Date ?? Date())
                }
                DispatchQueue.main.async {
                    self.scoreTable.reloadData()
                }
            } catch {
                print("Failed to fetch high scores: \(error)")
            }
        }
    
    
    @objc func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return highScores.count
    }
    
    @objc(tableView:cellForRowAtIndexPath:) internal func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let scoreEntry = highScores[indexPath.row]
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        cell.textLabel?.text = "Score: \(scoreEntry.score) - Date: \(dateFormatter.string(from: scoreEntry.date))"
        return cell
    }
    
}
