import SpriteKit

class DiceLabel:SKShapeNode {
    var label:SKLabelNode!
    
    override init() {
        super.init()
        fillColor = UIColor.purpleColor()
        label = SKLabelNode()
        label = SKLabelNode(fontNamed: "MarkerFelt")
        setDiceNumber(0)
        label.fontSize = 20
        label.fontColor = UIColor.whiteColor()
        label.verticalAlignmentMode = .Center
        addChild(label)
    }
    
    func setDiceNumber(number:Int) {
        label.text = "Diceroll: \(number)"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
