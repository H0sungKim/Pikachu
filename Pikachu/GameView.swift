//
//  GameView.swift
//  Pikachu
//
//  Created by Hello on 2023/12/07.
//


import UIKit
import AVFoundation

class GameView: UIView {
    
    class Pikachu {
        enum Status: Int {
            case standL = 0
            case standR
            case walkLeft
            case walkRight
            case ready
            case jump
            case hurt
            case dead
        }
        
        var status: Status
        let images: [UIImage]
        var statusFlag: Int
        
        let x: Int = 50
        var y: Int = 400
        
        init() {
            self.status = .standL
            self.images = [
                UIImage(named: "pikastand.png")!,
                UIImage(named: "pikastand.png")!,
                UIImage(named: "pikawalkleft.png")!,
                UIImage(named: "pikawalkright.png")!,
                UIImage(named: "pikaready.png")!,
                UIImage(named: "pikajump.png")!,
                UIImage(named: "pikahurt.png")!,
                UIImage(named: "pikadead.png")!,
            ]
            self.statusFlag = 0
        }
        
        func draw() {
            self.images[self.status.rawValue].draw(at: CGPoint(x: self.x, y: self.y))
        }
        func updateStatus() {
            switch self.status {
            case .standL:
                if self.statusFlag == 2 {
                    self.status = .walkLeft
                    self.statusFlag = 0
                } else {
                    self.statusFlag += 1
                }
            case .standR:
                if self.statusFlag == 2 {
                    self.status = .walkRight
                    self.statusFlag = 0
                } else {
                    self.statusFlag += 1
                }
            case .walkLeft:
                if self.statusFlag == 2 {
                    self.status = .standR
                    self.statusFlag = 0
                } else {
                    self.statusFlag += 1
                }
            case .walkRight:
                if self.statusFlag == 2 {
                    self.status = .standL
                    self.statusFlag = 0
                } else {
                    self.statusFlag += 1
                }
            case .ready:
                if self.statusFlag == 4 {
                    self.status = .jump
                    self.statusFlag = 0
                } else {
                    self.statusFlag += 1
                }
            case .jump:
                if self.statusFlag == 6 {
                    self.status = .standL
                    self.statusFlag = 0
                } else {
                    self.statusFlag += 1
                    self.y = 400 + (self.statusFlag*self.statusFlag - 6*self.statusFlag)*10
                }
            case .hurt:
                if self.statusFlag == 10 {
                    self.status = .dead
                    self.statusFlag = 0
                } else {
                    self.statusFlag += 1
                }
            case .dead:
                break
            }
        }
    }
    
    class Cloud {
        let type: Int
        var x: Int
        let y: Int
        
        init(type: Int, x: Int) {
            self.type = type
            self.x = x
            self.y = Int.random(in: 100...300)
        }
    }
    
    class Snorlax {
        
    }
    
    private var backgroundSoundPlayer: AVAudioPlayer?
    private var screenWidth: Int = 0
    private var screenHeight: Int = 0
    
    private var gameTimer: Timer!
    
    private var pikachu: Pikachu = Pikachu()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    private func initialize() {
        screenWidth = Int(self.frame.width)
        screenHeight = Int(self.frame.height)
        gameTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateScreen), userInfo: nil, repeats: true)
    }
    
    
    @objc private func updateScreen() {
        setNeedsDisplay()
        pikachu.updateStatus()
    }
    

    
    private func playSound(sound: Int) {
        
    }
    
    override func draw(_ rect: CGRect) {
        // draw background
        pikachu.draw()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if pikachu.status.rawValue < 4 {
            pikachu.status = .ready
            setNeedsDisplay()
        }
    }
}
