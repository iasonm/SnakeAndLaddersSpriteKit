import SpriteKit

class PlayButton:SKShapeNode {
    
    enum State {
        case RollDice(pawn:Int)
        case PawnMoving(pawn:Int)
        case GameWon
    }
    
    var label:SKLabelNode!
    var observer: PlayButtonObserver!
    var state:State {
        didSet {
            switch state {
            case .RollDice(let pawn):
                userInteractionEnabled = true
                fillColor = UIColor.orangeColor()
                label.fontColor = UIColor.greenColor()
                label.text = "Player \(pawn + 1) roll!"
            case .PawnMoving(let pawn):
                userInteractionEnabled = false
                fillColor = UIColor.purpleColor()
                label.fontColor = UIColor.whiteColor()
                label.text = "Player \(pawn + 1) moving!"
            case .GameWon:
                userInteractionEnabled = true
                fillColor = UIColor.greenColor()
                label.fontColor = UIColor.purpleColor()
                label.text = "New Game?"
            }
        }
    }
    
    override init() {
        state = .RollDice(pawn: 0)
        super.init()
        userInteractionEnabled = true
        fillColor = UIColor.orangeColor()
        label = SKLabelNode()
        label = SKLabelNode(fontNamed: "MarkerFelt")
        label.fontSize = 20
        label.verticalAlignmentMode = .Center
        
        label.text = "Player 1 Roll!"
        label.fontColor = UIColor.whiteColor()
        addChild(label)
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        observer.playButtonPressed(self)
        super.touchesBegan(touches, withEvent: event)
    }
    
}

