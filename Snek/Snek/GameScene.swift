//
//  GameScene.swift
//  Snek
//
//  Created by Mayank Talwar on 28/02/21.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var entities = [GKEntity]()
    var graphs = [String : GKGraph]()
    
    private var lastUpdateTime : TimeInterval = 0
    private var label : SKLabelNode?
    private var snakeBody : [SKShapeNode]?
    private var blockSize: CGFloat?
    
    private var directionChange: Bool = false
    enum Direction{case UP; case DOWN; case LEFT; case RIGHT}
    private var direction: Direction?
    
    private var food: SKShapeNode?

    private func getRandPoint(w: CGFloat) -> CGPoint{
        let height = self.size.height
        let width = self.size.width
        return CGPoint(x: Int(arc4random_uniform(UInt32(width) - UInt32(w))) - Int(width/2), y: Int(arc4random_uniform(UInt32(height) - UInt32(w))) - Int(height/2))
    }
    private func getHeadPhy(w: CGFloat) -> SKPhysicsBody{
        let phy = SKPhysicsBody(rectangleOf: CGSize(width: w, height: w))
        phy.affectedByGravity = false
        return phy
    }

    override func sceneDidLoad() {
        
        self.lastUpdateTime = 0
        let screenHeight = self.size.height
//        let screenWidth = self.size.width

        self.label = self.childNode(withName: "//headingLabel") as? SKLabelNode
        if let label = self.label {
            label.position = CGPoint(x: 0, y: screenHeight/2 - label.fontSize / 2)
        }
        
        let w = (self.size.width + self.size.height) * 0.02
        self.blockSize = w
        
        self.snakeBody = [SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)]
        
        if let snakeBody = self.snakeBody {
//            snakeBody[0].strokeColor = SKColor.purple
            snakeBody[0].fillColor = SKColor.white
//            snakeBody[0].run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
            snakeBody[0].physicsBody = self.getHeadPhy(w: w)
        }
        self.addChild((snakeBody?[0])!)
        
        self.food = SKShapeNode.init(circleOfRadius: 2 * w / 3)
        if let f = self.food{
            f.fillColor = SKColor.red
            f.position = self.getRandPoint(w: 2 * w / 3)
            f.physicsBody = SKPhysicsBody(circleOfRadius: 2 * w / 3)
            f.physicsBody?.affectedByGravity = false
            f.physicsBody?.collisionBitMask = 0x00000000
            self.addChild(f)
        }
    }

    override func keyDown(with event: NSEvent) {
        if self.label?.text == "Snek time POGCHAMP"{
            self.removeChildren(in: [self.label!])
        }
        switch event.keyCode {
//            case 0x31:
//                if let label = self.label {
//                    label.run(SKAction.init(named: "Pulse")!, withKey: "fadeInOut")
//                }
            case 126:
                if self.direction != Direction.DOWN {
                    self.direction = Direction.UP
                    self.directionChange = true
                }
            case 125:
                if self.direction != Direction.UP {
                    self.direction = Direction.DOWN
                    self.directionChange = true
                }
            case 123:
                if self.direction != Direction.RIGHT {
                    self.direction = Direction.LEFT
                    self.directionChange = true
                }
            case 124:
                if self.direction != Direction.LEFT {
                    self.direction = Direction.RIGHT
                    self.directionChange = true
                }
            default:
                print("keyDown: \(event.characters!) keyCode: \(event.keyCode)")
        }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        
        if (self.lastUpdateTime == 0) {
            self.lastUpdateTime = currentTime
        }
        let dt = currentTime - self.lastUpdateTime
        
        // Update entities
        for entity in self.entities {
            entity.update(deltaTime: dt)
        }
        if let snake = self.snakeBody{
            let size = snake.count
            if(size > 1)
            {
                for i in 1...size - 1{
                    snake[size - i].run(SKAction.move(to: snake[size - i - 1].position, duration: 0.3))
                }
            }
            if let head = snake.first{
                if directionChange{
                    let w = self.blockSize!
                    head.removeAllActions()
                    var vector = CGVector(dx: 0, dy: 0)
                    switch direction!{
                        case Direction.UP:
                            vector.dy = w
                        case Direction.DOWN:
                            vector.dy = -1 * w
                        case Direction.LEFT:
                            vector.dx = -1 * w
                        case Direction.RIGHT:
                            vector.dx = w
                    }
                    head.run(SKAction.repeatForever(SKAction.move(by: vector, duration: 0.3)))
                    self.directionChange = false
                }
                if(size > 4)
                {
                    for i in 4...size - 1{
                        if head.physicsBody?.allContactedBodies().contains(snake[i].physicsBody!) == true {
                            self.removeAllChildren()
                            if let gameOver = self.label{
                                gameOver.text = "Game Over, score: \(size)"
                                self.addChild(gameOver)
                            }
                        }
                    }
                }
                if let f = self.food{
                    if head.physicsBody?.allContactedBodies().contains(f.physicsBody!) == true {
                        let w = self.blockSize!
                        f.position = self.getRandPoint(w: w)
                        let n = SKShapeNode.init(rectOf: CGSize.init(width: w, height: w), cornerRadius: w * 0.3)
                        n.fillColor = SKColor.white
                        n.position = head.position
                        switch(direction!){
                            case Direction.UP:
                                n.position.y += w - 1
                            case Direction.DOWN:
                                n.position.y -= w - 1
                            case Direction.LEFT:
                                n.position.x -= w - 1
                            case Direction.RIGHT:
                                n.position.x += w - 1
                        }
                        n.physicsBody = self.getHeadPhy(w: w)
                        head.run(SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 1)))
                        snakeBody?.insert(n, at: 0)
                        self.addChild(n)
//                        self.directionChange = true;
                    }
                }
            }
        }
        
        self.lastUpdateTime = currentTime
    }
}
