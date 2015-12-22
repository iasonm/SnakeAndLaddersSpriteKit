import SpriteKit

class SpriteButton: SKSpriteNode {
    
    var label:SKLabelNode!
    var observer: SpriteButtonObserver!
    
    override init(texture: SKTexture?, color: UIColor, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        userInteractionEnabled = true
        label = SKLabelNode(fontNamed: "MarkerFelt")
        label.text = "Player 1 Roll!"
        label.fontSize = 20
        label.fontColor = UIColor.whiteColor()
        label.verticalAlignmentMode = .Center
        addChild(label)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        observer.spriteButtonPressed(self)
        super.touchesBegan(touches, withEvent: event)
    }
}

