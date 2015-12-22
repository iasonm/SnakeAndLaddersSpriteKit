import SpriteKit
import AVFoundation

protocol BoardObserver {
    func pawnBeganMoving(pawn:SKSpriteNode)
    func pawnStoppedMoving(pawn:SKSpriteNode)
    func gameWon(pawn:SKSpriteNode)
}

protocol SpriteButtonObserver {
    func spriteButtonPressed(button:SKSpriteNode)
}

class GameScene: SKScene, BoardObserver, SpriteButtonObserver {
    
    var board:Board!
    var playButton:SpriteButton!
    var diceLabel:SpriteButton!
    var game:SnakesAndLaddersGame!
    var pawnMoving = false
    var click:SKAudioNode!
    var currentMove = Move(pawn:0, startPosition: 0, endPosition:0, diceRoll:0, won:false)
    
    var squareSide:CGFloat {
        return size.width / 5
    }
    var gridUnit:CGFloat {
        return size.width / 10
    }
    var numberOfPlayers = 4
    var boardStartPosition:CGPoint {
        return CGPoint(x: board.boardImage.frame.minX + gridUnit, y: board.boardImage.frame.minY + 3 * gridUnit)
    }
    
    func translatePositionToScenePosition(position:Int)->CGPoint {
        let square = board.positionToSquare(position)
        let x = boardStartPosition.x + CGFloat(square.column) * squareSide
        let y = boardStartPosition.y + CGFloat(square.row) * squareSide
        return CGPoint(x: x, y: y)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(size: CGSize) {
        super.init(size: size)
        physicsWorld.gravity = CGVectorMake(0, 0)
        game = SnakesAndLaddersGame()
        addBoard()
        addPlayButton()
        addDiceLabel()
    }
    
    override func didMoveToView(view: SKView) {
    }
    
    func startGame() {
        game = SnakesAndLaddersGame()
        currentMove = Move(pawn:0, startPosition: 0, endPosition:0, diceRoll:0, won:false)
        if board.boardImage.inParentHierarchy(self) {
            board.boardImage.removeFromParent()
        }
        if playButton.inParentHierarchy(self) {
            playButton.removeFromParent()
        }
        if diceLabel.inParentHierarchy(self) {
            diceLabel.removeFromParent()
        }
        addBoard()
        addPlayButton()
        addDiceLabel()
    }
    
    func addBoard() {
        board = Board(width: size.width, numberOfPawns: 4, boardObserver: self)
        board.boardImage.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(board.boardImage)
    }
    
    func addPlayButton() {
        let playButtonSize = CGSize(width: gridUnit * 7, height: gridUnit * 2)
        let playButtonPosition = CGPoint(x: board.boardImage.frame.maxX - playButtonSize.width/2, y: board.boardImage.frame.minY)
        playButton = SpriteButton(texture: nil, color: UIColor.orangeColor(), size: playButtonSize)
        playButton.position = playButtonPosition
        playButton.observer = self
        addChild(playButton)
    }
    
    func addDiceLabel() {
        let backgroundSize = CGSize(width: (squareSide * 2) + 10, height: squareSide + 10)
        let backgroundShape = SKShapeNode(rectOfSize: backgroundSize)
        backgroundShape.fillColor = UIColor.cyanColor()
        backgroundShape.position = CGPoint(x: size.width/2, y: board.boardImage.frame.maxY)
        let filter  = CIFilter(name: "CIGaussianBlur")!
        filter.setValue(20.0, forKey: "inputRadius")
        let effect = SKEffectNode()
        effect.filter = filter
        effect.addChild(backgroundShape)
        diceLabel = SpriteButton(texture: nil, color: UIColor.cyanColor(), size: CGSize(width: squareSide * 2, height: squareSide))
        diceLabel.label.text = "Diceroll: 0"
        diceLabel.label.fontSize = 20
        diceLabel.label.fontColor = UIColor.purpleColor()
        diceLabel.position = CGPoint(x: size.width/2, y: board.boardImage.frame.maxY)
        addChild(effect)
        addChild(diceLabel)
    }
    
    func spriteButtonPressed(button: SKSpriteNode) {
        guard !pawnMoving else { return }
        guard !currentMove.won else {
            startGame()
            return
        }
        guard let move = game.nextMove() else { return }
        currentMove = move
        diceLabel.label.text = "Diceroll: \(move.diceRoll)"
        board.activePawnIndex = move.pawn
        board.executeMove(move)
    }
    
    func pawnBeganMoving(pawn: SKSpriteNode) {
        pawnMoving = true
        playButton.color = UIColor.purpleColor()
        playButton.label.text = "Player \(currentMove.pawn + 1) moving!"
    }
    
    func pawnStoppedMoving(pawn: SKSpriteNode) {
        pawnMoving = false
        playButton.color = UIColor.orangeColor()
        playButton.label.text = "Player \(game.nextPawn + 1) roll!"
    }
    
    func gameWon(pawn: SKSpriteNode) {
        pawnMoving = false
        diceLabel.color = UIColor.greenColor()
        diceLabel.label.text = "Player \(currentMove.pawn + 1) won!"
        playButton.color = UIColor.greenColor()
        playButton.label.text = "New Game?"
    }
    
}
