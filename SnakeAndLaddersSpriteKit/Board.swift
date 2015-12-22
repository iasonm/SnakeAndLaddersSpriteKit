import SpriteKit

struct Board {
    
    typealias Pawn = SKSpriteNode
    typealias Square = (column: Int, row: Int)
    
    let boardImageName = "board"
    let boardMatrix:[Square] = [
        (0,0),
        (0,1), (1,1), (2,1), (3,1), (4,1),
        (4,2), (3,2), (2,2), (1,2), (0,2),
        (0,3), (1,3), (2,3), (3,3), (4,3),
        (4,4), (3,4), (2,4), (1,4), (0,4),
        (0,5), (1,5), (2,5), (3,5), (4,5),
        (4,6)
    ]
    var pawns = [Pawn]()
    var activePawnIndex = 0
    let pawnNames = ["pawn1","pawn2","pawn3","pawn4"]
    let pawnAnchorPoints = [CGPoint(x: 1, y: 0), CGPoint(x: 0, y: 0), CGPoint(x: 1, y: 1), CGPoint(x: 0, y: 1)]
    let boardImage:SKSpriteNode
    let imageWidth:CGFloat
    var boardObserver:BoardObserver
    
    var numberOfPawns:Int {
        return pawns.count
    }
    
    var squareGrid:CGFloat {
        return imageWidth / 5
    }
    
    var pawnGrid:CGFloat {
        return imageWidth / 10
    }
    
    var boardStartPosition:CGPoint {
        return CGPoint(x: -2 * squareGrid, y: -3 * squareGrid)
    }
    
    init(width:CGFloat, numberOfPawns:Int, boardObserver:BoardObserver) {
        boardImage = SKSpriteNode(imageNamed: boardImageName)
        imageWidth = width
        self.boardObserver = boardObserver
        boardImage.size = CGSize(width: width, height: width + 2 * squareGrid)
        for idx in 0 ..< min( max(numberOfPawns, 1), 4) {
            addPawn(idx)
        }
    }
    
    mutating func addPawn(number:Int) {
        let sprite = SKSpriteNode(imageNamed: pawnNames[number])
        sprite.size = CGSize(width: pawnGrid, height: pawnGrid)
        sprite.anchorPoint = pawnAnchorPoints[number]
        sprite.position = boardStartPosition
        sprite.name = pawnNames[number]
        let pawn = sprite
        pawns.append(pawn)
        boardImage.addChild(pawn)
    }
    
    mutating func executeMove(move:Move) {
        activePawnIndex = move.pawn
        let pawn = pawns[activePawnIndex]
        let startPosition = move.startPosition
        let stepDestination = move.startPosition + move.diceRoll
        let finalDestination = move.endPosition
        let pawnMoving = SKAction.runBlock{
            self.boardObserver.pawnBeganMoving(pawn)
        }
        let pawnStopped = SKAction.runBlock{
            self.boardObserver.pawnStoppedMoving(pawn)
        }
        let pawnWon = SKAction.runBlock{
            self.boardObserver.gameWon(pawn)
        }
        let stepSequence = stepPawnFrom(startPosition, to: stepDestination)
        let jumpSequence = jumpPawnFrom(stepDestination, to: finalDestination)
        var sequenceArray:[SKAction] = []
        if move.won {
            pawn.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            pawn.zPosition = 0
            sequenceArray = [pawnMoving,stepSequence,wonSequence(),pawnWon]
        } else {
            sequenceArray = [pawnMoving,stepSequence,jumpSequence,pawnStopped]
        }
        pawn.runAction(SKAction.sequence(sequenceArray))
    }
    
    func stepPawnFrom(startingPosition:Int, to endingPosition:Int)->SKAction {
        var sequenceArray:[SKAction] = []
//        let steps = endingPosition - startingPosition
        let wait = SKAction.waitForDuration(0.1)
        for step in startingPosition + 1 ... endingPosition {
            let point = positionToPoint(step)
            let move = SKAction.moveTo(point, duration: 0.15)
            sequenceArray.append(move)
            sequenceArray.append(wait)
        }
        return SKAction.sequence(sequenceArray)
     }
    
    func jumpPawnFrom(startingPosition:Int, to endingPosition:Int)->SKAction {
        let startPoint = positionToPoint(startingPosition)
        let endPoint = positionToPoint(endingPosition)
        let xSide = fabs(endPoint.x - startPoint.x)
        let ySide = fabs(endPoint.y - startPoint.y)
        let distance = sqrt(xSide * xSide + ySide * ySide)
        let duration = Double(distance / 250)
        let wait = SKAction.waitForDuration(0.2)
        let move = SKAction.moveTo(endPoint, duration: duration)
        return SKAction.sequence([wait,move])
    }
    
    func wonSequence()->SKAction {
        let center = SKAction.moveTo(CGPointZero, duration: 0.5)
        let grow = SKAction.scaleBy(4.0, duration: 0.5)
        return SKAction.sequence([center,grow])
        
    }
    
    func positionToPoint(position:Int)->CGPoint {
        let square = positionToSquare(position)
        return squareToPoint(square)
    }
    
    func positionToSquare(var position:Int)-> Square {
        position = min( max(position, 0), boardMatrix.count - 1)
        return Square(column: boardMatrix[position].column, row: boardMatrix[position].row)
    }
    
    func squareToPoint(square:Square)->CGPoint {
        let x = boardStartPosition.x + CGFloat(square.column) * squareGrid
        let y = boardStartPosition.y + CGFloat(square.row) * squareGrid
        return CGPoint(x: x, y: y)
    }
    
}

