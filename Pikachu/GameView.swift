//
//  GameView.swift
//  Pikachu
//
//  Created by 김기훈 on 2023/12/07.
//


// MARK: - Hello

import UIKit
import AVFoundation

class GameView: UIView {
    let BACKGROUND_SOUND: Int = 0
    let JUMP_SOUND: Int = 1
    let DEAD_SOUND: Int = 2
    
    var backgroundSoundPlayer: AVAudioPlayer?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initialize()
    }
    
    func initialize() {
        playSound(sound: BACKGROUND_SOUND)
    }
    
    
    
    override func draw(_ rect: CGRect) {
        //var drawable: UIImage? = UIImage(named: "pikastand.png")?.resizableImage(withCapInsets: .zero, resizingMode:.stretch)
        let drawable: UIImage? = UIImage(named: "pikastand.png")

//        let imageRect = CGRect(x: 50, y: 50, width: 200, height: 200)
        
        drawable!.draw(at: CGPoint(x: 50, y: 400))
    }
    
    func playSound(sound: Int) {
        var url: URL
        switch sound {
        case BACKGROUND_SOUND :
            url = Bundle.main.url(forResource: "route1", withExtension: "mp3")!
        case JUMP_SOUND :
            url = Bundle.main.url(forResource: "jump", withExtension: "wav")!
        case DEAD_SOUND :
            url = Bundle.main.url(forResource: "dead", withExtension: "wav")!
        default :
            return
        }
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            backgroundSoundPlayer = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            backgroundSoundPlayer?.numberOfLoops = -1
            guard let player = backgroundSoundPlayer else { return }
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
        
    }
}
