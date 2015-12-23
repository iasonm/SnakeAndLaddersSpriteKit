import SpriteKit
import AVFoundation

protocol BoardObserver {
    func boardState(state:Board.State)
}

protocol PlayButtonObserver {
    func playButtonPressed(button:SKShapeNode)
}

class GameScene: SKScene, BoardObserver, PlayButtonObserver {
    
    var board:Board!
    var playButton:PlayButton!
    var diceLabel:DiceLabel!
    var game:SnakesAndLaddersGame!
    var click:SKAudioNode!
    var currentMove = Move(pawn:0, nextPawn:0, startPosition: 0, endPosition:0, diceRoll:0, won:false)
    
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
        currentMove = Move(pawn:0, nextPawn:0, startPosition: 0, endPosition:0, diceRoll:0, won:false)
        board.resetPawns()
        playButton.state = .RollDice(pawn:0)
        diceLabel.setDiceNumber(0)
    }
    
    func addBoard() {
        board = Board(width: size.width, numberOfPawns: 4, boardObserver: self)
        board.boardImage.position = CGPoint(x: size.width / 2, y: size.height / 2)
        addChild(board.boardImage)
    }
    
    func addPlayButton() {
        let playButtonSize = CGSize(width: gridUnit * 7, height: gridUnit * 2)
        let playButtonPosition = CGPoint(x: board.boardImage.frame.maxX - playButtonSize.width/2, y: board.boardImage.frame.minY)
        playButton = PlayButton(rectOfSize: playButtonSize)
        playButton.position = playButtonPosition
        playButton.observer = self
        addChild(playButton)
    }
    
    func addDiceLabel() {
        diceLabel = DiceLabel(rectOfSize: CGSize(width: squareSide * 2, height: squareSide))
        diceLabel.position = CGPoint(x: size.width/2, y: board.boardImage.frame.maxY)
        addChild(diceLabel)
    }
    
    func playButtonPressed(button: SKShapeNode) {
        if currentMove.won {
            startGame()
        } else {
            nextMove()
        }
    }
    
    func nextMove() {
        let move = game.nextMove()
        currentMove = move
        diceLabel.setDiceNumber(move.diceRoll)
        board.activePawnIndex = move.pawn
        board.executeMove(move)
    }
    
    func boardState(state: Board.State) {
        switch state {
        case .Stopped:
            playButton.state = .RollDice(pawn: currentMove.nextPawn)
        case .Moving:
            playButton.state = .PawnMoving(pawn: currentMove.pawn)
        case .Won:
            playButton.state = .GameWon
        }
    }
    
}
