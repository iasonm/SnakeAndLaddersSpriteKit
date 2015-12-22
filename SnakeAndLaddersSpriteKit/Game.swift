import Foundation
import GameplayKit

typealias Jump = (position:Int, jump:Int)

struct Move {
    let pawn:Int
    let startPosition:Int
    var endPosition:Int
    let diceRoll:Int
    let won:Bool
}



struct Track {
    
    let trackArray:[Int]
    
    var length:Int {
        return trackArray.count
    }
    
    init(length:Int,jumps:[Jump]) {
        var tempArray = [Int](count: length, repeatedValue: 0)
        for jump in jumps {
            tempArray[jump.position] = jump.jump
        }
        trackArray = tempArray
    }
    
    func generateMove(startPosition:Int, diceRoll:Int)->Int {
        let dicePosition = min(startPosition + diceRoll, trackArray.count - 1)
        let endPosition = dicePosition + trackArray[dicePosition]
        return endPosition
    }
}

struct SnakesAndLaddersGame {

    var pawnPositions = [0,0,0,0]
    var won = false
    var activePawn = -1
    let diceGenerator = GKRandomDistribution.d6()
    var lastRoll = 0
    let track = Track(
        length: 27,
        jumps: [
           (position: 3,jump: 8),
           (position: 6,jump: 11),
           (position: 9,jump: 9),
           (position: 10,jump: 2),
           (position: 14,jump: -10),
           (position: 19,jump: -11),
           (position: 22,jump: -2),
           (position: 24,jump: -8)
        ]
    )
    
    var nextPawn:Int {
        return lastRoll == 6 ? activePawn : (activePawn + 1) % 4
    }
    
    mutating func nextMove()->Move? {
        guard !won else { return nil }        
        activePawn = nextPawn
        lastRoll = diceGenerator.nextInt()
        let startPosition = pawnPositions[activePawn]
        let endPosition = track.generateMove(startPosition, diceRoll: lastRoll)
        won = endPosition == track.length - 1
        pawnPositions[activePawn] = endPosition
        return Move(pawn: activePawn, startPosition: startPosition, endPosition: endPosition, diceRoll: lastRoll, won: won)
    }
    
}














