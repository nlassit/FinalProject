//
//  GameViewController.swift
//  MemoryQuest
//
//  Created by Nathan Lassiter on 4/27/24.
//

import UIKit
import AVFoundation
import CoreData

class GameViewController: UIViewController, AVAudioPlayerDelegate{
    
    
    @IBOutlet weak var startGameButton: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button1: UIButton!

    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    

       
    var audioPlayer: AVAudioPlayer?
    var sequence = [Int]()
    var userSequenceIndex = 0
    var level = 1
    var score = 0
       
    override func viewDidLoad() {
               super.viewDidLoad()
               loadAudioFiles()
               updateUI(level: level, score: 0)
               setupButtonImages()
           }
    func loadAudioFiles() {
        if let url = Bundle.main.url(forResource: "sound1", withExtension: "mp3") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.prepareToPlay()
            } catch {
                print("Error loading sound1 mp3: \(error)")
            }
        } else {
            print("Error: sound 1 mp3 not found")
        }
    }
    
    func updateUI(level: Int, score: Int) {
        levelLabel.text = "Level \(level)"
        scoreLabel.text = "\(score) pts"
    }
    
    func setupButtonImages() {
           button1.setImage(UIImage(named: "redtile"), for: .normal)
           button1.setImage(UIImage(named: "redpressed"), for: .selected)

           button2.setImage(UIImage(named: "greentile"), for: .normal)
           button2.setImage(UIImage(named: "greenpressed"), for: .selected)

           button3.setImage(UIImage(named: "yellowtile"), for: .normal)
           button3.setImage(UIImage(named: "yellowpressed"), for: .selected)

           button4.setImage(UIImage(named: "bluetile"), for: .normal)
           button4.setImage(UIImage(named: "bluepressed"), for: .selected)
       }

    @IBAction func startGamePressed(_ sender: UIButton) {
           startGameButton.isHidden = true
           generateSequence()
       }
    
    func generateSequence() {
           sequence.append(Int.random(in: 0..<4))
           playSequence(index: 0)
    }
    
    // Creates sequence for the user to follow starting with one and going up each level by 1
    func playSequence(index: Int) {
        if index < sequence.count {
            let buttonIndex = sequence[index]
            let button = getButtonForIndex(index: buttonIndex)
            button?.isSelected = true

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                button?.isSelected = false
                self.playSequence(index: index + 1)
            }
        } else {
            userSequenceIndex = 0
        }
    }
    
    // switch statement to get the button associated with index
    func getButtonForIndex(index: Int) -> UIButton? {
        switch index {
        case 0:
            return button1
        case 1:
            return button2
        case 2:
            return button3
        case 3:
            return button4
        default:
            return nil
        }
    }
       
    // Once the sequence is done and the user clicks on any of the buttons this action is done (all four tiles linked)
    @IBAction func buttonPressed(_ sender: UIButton) {
           let tag = sender.tag
               playSound()

               if sequence.isEmpty {
                   print("Sequence is empty.")
                   return
               }

               if tag == sequence[userSequenceIndex] {
                   userSequenceIndex += 1
                   print("Correct! Next index: \(userSequenceIndex)")

                   if userSequenceIndex == sequence.count {
                       print("Completed sequence, advancing to next level.")
                       nextLevel()
                   }
               } else {
                   print("Incorrect sequence.")
                   resetGame()
               }
        }
    
    func nextLevel() {
        level += 1
        score += 10
        updateUI(level: level, score: score)
        userSequenceIndex = 0
        generateSequence()
    }
    
    func resetGame() {
        // after game ends need to save highscore (if statement ?)
        if score > 0 {
            saveHighScore(score)
        }
        sequence = []
        level = 1
        score = 0
        userSequenceIndex = 0
        updateUI(level: level, score: score)
        startGameButton.isHidden = false
        navigationController?.navigationBar.isHidden = false
    }
    
    func saveHighScore(_ score : Int) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            
            let highScore = NSEntityDescription.insertNewObject(forEntityName: "HighScore", into: context)
            
            highScore.setValue(Int64(score), forKey: "score")
            highScore.setValue(Date(), forKey: "date")
            
        do {
            try context.save()
            print("successful save")
        } catch {
            print("error saving")
        }
    }
       
    func playSound() {
        audioPlayer?.play()
    }
}
