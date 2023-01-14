//
//  ViewController.swift
//  CatchTheJerry
//
//  Created by Mehmet Kubilay Akdemir on 13.01.2023.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var timerLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var highscoreLabel: UILabel!
    @IBOutlet weak var jerrry: UIImageView!

    var timer = Timer()
    var respawnTimer = Timer()
    var counter: Int = 0
    var score: Int = 0
    let storedHighScore = UserDefaults.standard.object(forKey: "highscore")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let highScore = storedHighScore as? Int {
            highscoreLabel.text = "Highscore: \(highScore)"
        } else {
            highscoreLabel.text = "Highscore: 0"
        }
    
    }
    @IBAction func didTappedNewGameButton(_ sender: Any) {
        newGame()
    }
    
    @IBAction func didTappedEndGameButton(_ sender: Any) {
        jerrry.isUserInteractionEnabled = false
        counter = 0
        timer.invalidate()
        respawnTimer.invalidate()
    }

    private func startTimer(){
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerFunction), userInfo: nil, repeats: true)
        respawnTimer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(respawnTimerFunction), userInfo: nil, repeats: true)
    }
    
    @objc func respawnTimerFunction() {
        let width = view.frame.size.width
        let height = view.frame.size.height
        
        let jerryWidth = Int(width / 5)
        let jerryHeight = Int(height / 8)
        
        let randomX = Int.random(in: 20...(Int(width) - jerryWidth - 20))
        let randomY = Int.random(in: 200...(Int(height) - jerryHeight - 250))
        
        jerrry.frame = CGRect(x: randomX, y: randomY, width: 80, height: 100)
    }

    @objc func timerFunction(){
        
        if counter != 0 {
            counter -= 1
            timerLabel.text = "Time: \(counter)"

        } else {
            timer.invalidate()
            respawnTimer.invalidate()
            endGame()
        }
    }
    
    @objc func changeScore(){
        score += 1
        scoreLabel.text = "Score: \(score)"
    }
    
    private func newGame(){
        
        jerrry.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(changeScore))
        jerrry.addGestureRecognizer(gestureRecognizer)
        
        counter = 10
        score = 0
        scoreLabel.text = "Score: \(score)"
        timerLabel.text = "Time: \(counter)"
        startTimer()
    }
    
    private func endGame(){
        
        jerrry.isUserInteractionEnabled = false
        
        if let highScore = storedHighScore as? Int {
            if score > highScore {
                UserDefaults.standard.set(score, forKey: "highscore")
                highscoreLabel.text = "Highscore: \(score)"
            }
        } else {
            UserDefaults.standard.set(score, forKey: "highscore")
            highscoreLabel.text = "Highscore: \(score)"
        }
        
        
        showAlert(alertTitle: "Time's Up",
                  alertMessage: "Do you want to play again?",
                  firstButtonTitle: "No",
                  secondButtonTitle: "Replay",
                  buttonHandler: { _ in
            self.newGame()
        })
    }
    

    
    private func showAlert(alertTitle: String,
                           alertMessage: String,
                           preferredStyle: UIAlertController.Style = .alert,
                           firstButtonTitle: String,
                           secondButtonTitle: String,
                           buttonHandler: ((UIAlertAction)-> Void)? = nil ) {
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: preferredStyle)
        let firstButton = UIAlertAction(title: firstButtonTitle, style: .default)
        let secondButton = UIAlertAction(title: secondButtonTitle, style: .default, handler: buttonHandler)
        alert.addAction(firstButton)
        alert.addAction(secondButton)
        present(alert, animated: true)
    }
}

