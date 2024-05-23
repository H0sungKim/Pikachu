//
//  GameView.swift
//  Pikachu
//
//  Created by Hosung.Kim on 2023/12/07.
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
        let imgShadow: UIImage
        
        let x: Int = 50
        let y: Int = 400
        var jumpHeight: Int = 0
        let imgWidth: Int
        let imgHeight: Int
        
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
            self.imgShadow = UIImage(named: "shadow")!
            self.imgWidth = Int(self.images[0].size.width)
            self.imgHeight = Int(self.images[0].size.height - self.imgShadow.size.height/2)
        }
        
        func draw() {
            self.imgShadow.draw(at: CGPoint(x: self.x, y: self.y+self.imgHeight))
            self.images[self.status.rawValue].draw(at: CGPoint(x: self.x, y: self.y+self.jumpHeight))
        }
        func updateStatus() {
            switch self.status {
            case .standL:
                if self.statusFlag >= 2 {
                    self.status = .walkLeft
                    self.statusFlag = 0
                } else {
                    self.statusFlag += 1
                }
            case .standR:
                if self.statusFlag >= 2 {
                    self.status = .walkRight
                    self.statusFlag = 0
                } else {
                    self.statusFlag += 1
                }
            case .walkLeft:
                if self.statusFlag >= 2 {
                    self.status = .standR
                    self.statusFlag = 0
                } else {
                    self.statusFlag += 1
                }
            case .walkRight:
                if self.statusFlag >= 2 {
                    self.status = .standL
                    self.statusFlag = 0
                } else {
                    self.statusFlag += 1
                }
            case .ready:
                if self.statusFlag >= 2 {
                    self.status = .jump
                    self.statusFlag = 0
                } else {
                    self.statusFlag += 1
                }
            case .jump:
                if self.statusFlag >= 12 {
                    self.status = .standL
                    self.statusFlag = 0
                } else {
                    self.statusFlag += 1
                    self.jumpHeight = (self.statusFlag*self.statusFlag - 12*self.statusFlag)*3
                }
            case .hurt:
                if self.statusFlag >= 10 && self.jumpHeight >= 0 {
                    self.status = .dead
                    self.statusFlag = 0
                } else {
                    self.statusFlag += 1
                    if jumpHeight < 0 {
                        self.jumpHeight += 6
                    }
                }
            case .dead:
                break
            }
        }
    }
    
    class Cloud {
        static let width: Int = Int(UIImage(named: "cloud1.png")!.size.width)
        let type: Int
        let x: Int
        let y: Int
        var progress: Int = 0
        let image: UIImage
        
        init(type: Int, x: Int) {
            self.type = type
            self.x = x
            self.y = Int.random(in: 50...300)
            switch type {
            case 0:
                self.image = UIImage(named: "cloud1.png")!
            case 1:
                self.image = UIImage(named: "cloud2.png")!
            default:
                self.image = UIImage(named: "cloud1.png")!
            }
        }
        
        func draw() {
            self.image.draw(at: CGPoint(x: self.x-self.progress, y: self.y))
        }

    }
    
    class Snorlax {
        enum Status: Int {
            case sleep = 0
            case wakeup1
            case wakeup2
            case standup
            case roar
        }
        
        static let width: Int = Int(UIImage(named: "snorlaxroar.png")!.size.width)
        let x: Int
        let y: Int = 400
        var progress: Int = 0
        var status: Status = .sleep
        let imgShadow: UIImage
        let images: [UIImage]
        let imgHeight: Int
        var statusFlag: Int = 0
        
        init(x: Int) {
            self.x = x
            self.imgShadow = UIImage(named: "shadow.png")!
            self.images = [
                UIImage(named: "snorlaxsleep.png")!,
                UIImage(named: "snorlaxwakeup1.png")!,
                UIImage(named: "snorlaxwakeup2.png")!,
                UIImage(named: "snorlaxstandup.png")!,
                UIImage(named: "snorlaxroar.png")!,
            ]
            self.imgHeight = Int(self.images[4].size.height - self.imgShadow.size.height/2)
        }
        
        func draw() {
            self.imgShadow.draw(at: CGPoint(x: self.x-self.progress, y: self.y+self.imgHeight))
            self.images[self.status.rawValue].draw(at: CGPoint(x: self.x-self.progress, y: self.y))
        }
        func updateStatus() {
            switch status {
            case .sleep:
                if self.statusFlag >= 2 {
                    self.status = .wakeup1
                    self.statusFlag = 0
                } else {
                    self.statusFlag += 1
                }
            case .wakeup1:
                if self.statusFlag >= 2 {
                    self.status = .wakeup2
                    self.statusFlag = 0
                } else {
                    self.statusFlag += 1
                }
            case .wakeup2:
                if self.statusFlag >= 2 {
                    self.status = .standup
                    self.statusFlag = 0
                } else {
                    self.statusFlag += 1
                }
            case .standup:
                if self.statusFlag >= 2 {
                    self.status = .roar
                    self.statusFlag = 0
                } else {
                    self.statusFlag += 1
                }
            case .roar:
                break
            }
        }
    }
    
    var parentViewController: MainViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if let viewController = parentResponder as? MainViewController {
                return viewController
            }
        }
        return nil
    }
    
    private var backgroundSoundPlayer: AVAudioPlayer?
    private var jumpSoundPlayer: AVAudioPlayer?
    private var deadSoundPlayer: AVAudioPlayer?
    
    private var screenWidth: Int = 0
    private var screenHeight: Int = 0

    private var gameTimer: Timer!
    private var score: Int = 0
    
    private var pikachu: Pikachu = Pikachu()
    private var clouds: [Cloud] = []
    private var snorlaxes: [Snorlax] = []
    private var snorlaxFlag: Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    private func initialize() {
        screenWidth = Int(UIScreen.main.bounds.width)
        screenHeight = Int(UIScreen.main.bounds.height)
        gameTimer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        initializeSound()
    }
    
    
    @objc private func update() {
        setNeedsDisplay()
        updatePikachu()
        updateClouds()
        updateSnorlaxes()
        parentViewController?.setLbScore(score: score)
        score += 1
        if pikachu.status == .dead {
            gameTimer.invalidate()
            parentViewController?.setBestScore(score: score)
            backgroundSoundPlayer?.stop()
        }
        if pikachu.status == .jump && pikachu.statusFlag == 0 {
            jumpSoundPlayer?.play()
        }
        if pikachu.status == .hurt && pikachu.statusFlag == 1 {
            deadSoundPlayer?.play()
        }
    }
    private func updatePikachu() {
        pikachu.updateStatus()
    }
    private func updateClouds() {
        if Int.random(in: 0...50) == 0 {
            clouds.append(Cloud(type: Int.random(in: 0...1), x: screenWidth))
        }
        var removeIndex: Int = -1
        for i in 0..<clouds.count {
            clouds[i].progress += 1
            if clouds[i].progress == screenWidth+Cloud.width {
                removeIndex = i
            }
        }
        if removeIndex != -1 {
            clouds.remove(at: removeIndex)
        }
    }
    private func updateSnorlaxes() {
        snorlaxFlag -= 1
        if Int.random(in: 0...9) == 0 && snorlaxFlag < 0 {
            snorlaxes.append(Snorlax(x: screenWidth))
            snorlaxFlag = 20
        }
        var removeIndex: Int = -1
        for i in 0..<snorlaxes.count {
            snorlaxes[i].progress += 15
            if snorlaxes[i].progress > screenWidth/3 {
                snorlaxes[i].updateStatus()
            }
            if snorlaxes[i].progress == screenWidth+Snorlax.width {
                removeIndex = i
            }
            if snorlaxes[i].x - snorlaxes[i].progress - 50 > 0 && snorlaxes[i].x - snorlaxes[i].progress - 50 < pikachu.imgWidth {
                if pikachu.y+pikachu.imgHeight+pikachu.jumpHeight > snorlaxes[i].y {
                    pikachu.status = .hurt
                    pikachu.statusFlag = 0
                }
            }
        }
        if removeIndex != -1 {
            clouds.remove(at: removeIndex)
        }
    }
    private func initializeSound() {
        playBackgroundSound()
        let jumpUrl: URL = Bundle.main.url(forResource: "jump", withExtension: "wav")!
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            jumpSoundPlayer = try AVAudioPlayer(contentsOf: jumpUrl, fileTypeHint: AVFileType.wav.rawValue)
        } catch let error {
            print(error.localizedDescription)
        }
        let deadUrl: URL = Bundle.main.url(forResource: "dead", withExtension: "mp3")!
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            deadSoundPlayer = try AVAudioPlayer(contentsOf: deadUrl, fileTypeHint: AVFileType.mp3.rawValue)
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    private func playBackgroundSound() {
        let url: URL = Bundle.main.url(forResource: "route1", withExtension: "mp3")!
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            backgroundSoundPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            backgroundSoundPlayer?.numberOfLoops = -1
            
            backgroundSoundPlayer?.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    private func drawBackground() {
        let path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: screenWidth, height: 350))
        UIColor(red: 175/255, green: 236/255, blue: 255/255, alpha: 1).setFill()
        path.fill()
        let path2 = UIBezierPath(rect: CGRect(x: 0, y: 350, width: screenWidth, height: screenHeight - 350))
        UIColor(red: 168/255, green: 223/255, blue: 142/255, alpha: 1).setFill()
        path2.fill()
    }
    override func draw(_ rect: CGRect) {
        drawBackground()
        pikachu.draw()
        for i in clouds {
            i.draw()
        }
        for i in snorlaxes {
            i.draw()
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if pikachu.status.rawValue < 4 {
            pikachu.status = .ready
            pikachu.statusFlag = 0
        }
    }
}
