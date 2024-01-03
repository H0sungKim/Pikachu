//
//  MainViewController.swift
//  Pikachu
//
//  Created by 김기훈 on 2023/12/07.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var lbScore: UILabel!
    @IBOutlet weak var lbBestScore: UILabel!
    private var bestScore: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NSLog("2024.01.03 19:01")
        bestScore = UserDefaults.standard.integer(forKey: "BestScore")
        lbBestScore.text = "BestScore : \(bestScore)"
    }
    
    func setLbScore(score: Int) {
        lbScore.text = "Score : \(score)"
    }
    func setBestScore(score: Int) {
        if score > bestScore {
            bestScore = score
        }
        UserDefaults.standard.setValue(bestScore, forKey: "BestScore")
        lbBestScore.text = "BestScore : \(bestScore)"
    }
}
