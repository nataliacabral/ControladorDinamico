//
//  SpringSoundObject.swift
//  ControladorDinamico
//
//  Created by Natália Cabral on 12/11/14.
//  Copyright (c) 2014 Natália Cabral. All rights reserved.
//

import Foundation
import SpriteKit

struct SpringStatus
{
    var handlePosition:CGFloat
    var handleSpeed:CGFloat
}

class SpringSoundObject : SoundObject, Touchable, ModulatorNode
{
    override var gridHeight:CGFloat { get { return 3 } }
    override var gridWidth:CGFloat { get { return 1 } }

    var sticksList:Array<SKSpriteNode> = Array<SKSpriteNode>()
    var springHandle:SpringHandle?
    var springHandleBoundEdge:SKSpriteNode = SKSpriteNode()
    let springTrackTexture:SKTexture = SKTexture(imageNamed: "spring_background.png")
    let springEditTexture:SKTexture = SKTexture(imageNamed: "spring.png")

    let handlerWidthBorder:CGFloat = 3.5
    let stickWidthBorder:CGFloat = 18
    let springHeightBorder:CGFloat = 12

    var modulators:Array<Modulator> = Array<Modulator>()
    var springJoint:SKPhysicsJointSpring?
    
    var status:SpringStatus = SpringStatus(handlePosition: CGFloat(0), handleSpeed:CGFloat(0))
    var savedStatus : Array<SpringStatus> = Array<SpringStatus>(count: 4, repeatedValue: SpringStatus(handlePosition: CGFloat(0), handleSpeed: CGFloat(0)))
    
    override init()
    {
        super.init()
    }
    
    override init(texture: SKTexture!, color: UIColor!, size: CGSize)
    {
        super.init(texture: springEditTexture, color: color, size: size)
        self.iconImageName = "spring_icon.png"
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        self.savedStatus[0].handlePosition = CGFloat(aDecoder.decodeFloatForKey("handlePosition0"))
        self.savedStatus[1].handlePosition = CGFloat(aDecoder.decodeFloatForKey("handlePosition1"))
        self.savedStatus[2].handlePosition = CGFloat(aDecoder.decodeFloatForKey("handlePosition2"))
        self.savedStatus[3].handlePosition = CGFloat(aDecoder.decodeFloatForKey("handlePosition3"))
        
        self.savedStatus[0].handleSpeed = CGFloat(aDecoder.decodeFloatForKey("handleSpeed0"))
        self.savedStatus[1].handleSpeed = CGFloat(aDecoder.decodeFloatForKey("handleSpeed1"))
        self.savedStatus[2].handleSpeed = CGFloat(aDecoder.decodeFloatForKey("handleSpeed2"))
        self.savedStatus[3].handleSpeed = CGFloat(aDecoder.decodeFloatForKey("handleSpeed3"))
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
        aCoder.encodeFloat(Float(self.savedStatus[0].handlePosition), forKey: "handlePosition0")
        aCoder.encodeFloat(Float(self.savedStatus[1].handlePosition), forKey: "handlePosition1")
        aCoder.encodeFloat(Float(self.savedStatus[2].handlePosition), forKey: "handlePosition2")
        aCoder.encodeFloat(Float(self.savedStatus[3].handlePosition), forKey: "handlePosition3")
        
        aCoder.encodeFloat(Float(self.savedStatus[0].handleSpeed), forKey: "handleSpeed0")
        aCoder.encodeFloat(Float(self.savedStatus[1].handleSpeed), forKey: "handleSpeed1")
        aCoder.encodeFloat(Float(self.savedStatus[2].handleSpeed), forKey: "handleSpeed2")
        aCoder.encodeFloat(Float(self.savedStatus[3].handleSpeed), forKey: "handleSpeed3")
    }

    
    override init(gridSize:CGFloat) {
        super.init(gridSize:gridSize)
    }
    
    func loadHandle()
    {
        self.springHandle = nil
        self.removeAllChildren()
        if (self.springHandle == nil) {
            self.springHandle = SpringHandle()
            self.springHandle?.zPosition = 1
            self.springHandle!.size.width = self.size.width - (self.handlerWidthBorder * 2)
            let ratio:CGFloat = self.springHandle!.texture!.size().width / self.springHandle!.size.width
            self.springHandle!.size.height = self.springHandle!.texture!.size().height / ratio
            self.springHandle!.position.x = 0
            self.springHandle!.position.y = 0
            
            self.addChild(self.springHandle!);
        }
        
        for stickIndex in 0...25
        {
            var stick:SKSpriteNode = SKSpriteNode(imageNamed: "spring_stick.png")
            stick.size.width = self.size.width - (self.stickWidthBorder * 2)
            stick.size.height = self.springHandle!.size.height / 10
            stick.position.x = 2;
            stick.position.y = 0;
            self.sticksList.append(stick)
            self.addChild(stick);
        }
        self.updateSticksPosition()
        self.savedStatus = Array<SpringStatus>(count: 4, repeatedValue: SpringStatus(handlePosition: CGFloat(self.size.height / 2 - self.springHandle!.size.height / 2), handleSpeed: CGFloat(0)))
    }
    
    override func currentSoundIntensity() -> Float
    {
        return self.springHandle!.currentSoundIntensity()
    }
    
    override func touchStarted(position:CGPoint)
    {
    }
    
    override func touchMoved(position:CGPoint)
    {
        self.springHandle!.touchMoved(position)
    }
    
    override func touchEnded(position:CGPoint)
    {
    }
    
    func setModule(module:Float)
    {
        for modulator in self.modulators {
            modulator.modulate(module)
        }
    }
    
    func addModulator(modulator:Modulator) {
        self.modulators.append(modulator)
    }
    
    func updateSticksPosition()
    {
        if (self.springHandle != nil) {
            var handlePosition:CGFloat = self.springHandle!.position.y
            var handleSize:CGFloat = self.springHandle!.size.height

            let stickHeight:CGFloat = (self.sticksList[0] as SKSpriteNode).size.height
            let range:CGFloat = (self.size.height / 2) - handlePosition - handleSize / 2
            let distance:CGFloat = range / CGFloat(self.sticksList.count)
            var currentPosition:CGFloat = (self.size.height / 2) - 20

            for stick in self.sticksList {
                stick.position.y = currentPosition
                currentPosition -= distance
            }
        }
    }
    
    override func startPhysicalBody() {
        //super.startPhysicalBody()
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: CGRect(origin: CGPoint(x:-self.size.width / 2,y:-self.size.height / 2), size: self.size))
        self.physicsBody!.affectedByGravity = false
        self.physicsBody!.allowsRotation = false
        self.physicsBody!.dynamic = false
        
        springHandle!.physicsBody = SKPhysicsBody(rectangleOfSize: springHandle!.size)
        springHandle!.physicsBody?.collisionBitMask = 3
        springHandle!.physicsBody?.categoryBitMask = 3
        springHandle!.physicsBody?.contactTestBitMask = 3
        springHandle!.physicsBody?.dynamic = true
        springHandle!.physicsBody?.restitution = 0.6
        springHandle!.physicsBody?.linearDamping = 0
        springHandle!.physicsBody?.allowsRotation = false
        springHandle!.physicsBody?.affectedByGravity = false
        
        springHandleBoundEdge.physicsBody = SKPhysicsBody(edgeLoopFromRect: CGRect(
            origin: CGPoint(x:self.position.x - self.size.width / 2, y:self.position.y + springHeightBorder - self.size.height / 2),
            size: CGSize(width: self.size.width, height: self.size.height - (springHeightBorder * 2))))
        springHandleBoundEdge.physicsBody?.collisionBitMask = 3
        springHandleBoundEdge.physicsBody?.categoryBitMask
        springHandleBoundEdge.physicsBody?.dynamic = false

        let positionY:CGFloat = self.position.y
        let springHandleScenePosition = self.convertPoint(self.springHandle!.position, toNode: self.scene!)
        var springHandleAnchor = springHandleScenePosition
        self.springJoint = SKPhysicsJointSpring .jointWithBodyA(self.springHandle!.physicsBody!, bodyB:self.physicsBody!, anchorA:springHandleAnchor , anchorB:CGPoint(x: self.position.x, y: positionY))
        
        springJoint!.frequency = 2;//0.8;
        springJoint!.damping = 0.001;//0.5;
        self.scene?.physicsWorld .addJoint(springJoint!)
        self.scene?.addChild(self.springHandleBoundEdge)
    }

    
    override func update(currentTime: NSTimeInterval)
    {
        if (self.springHandle != nil) {
            self.updateSticksPosition()
        }
    }
    
    override func playObject() -> SoundObject
    {
        var result:SpringSoundObject = SpringSoundObject(
            texture:self.texture,
            color:self.color,
            size:self.size
        )
        result.texture = springTrackTexture
        result.position = self.position
        result.loadHandle()
        result.savedStatus = savedStatus
        return result
    }
    
    
    override func saveStatus(slot:Int)
    {
        self.status.handlePosition = self.springHandle!.position.y
        self.status.handleSpeed = self.springHandle!.physicsBody!.velocity.dy
        self.savedStatus[slot] = self.status;
    }
    
    override func loadStatus(slot:Int)
    {
        self.status = self.savedStatus[slot];
        self.springHandle!.position.y = self.status.handlePosition
        self.springHandle!.physicsBody!.velocity.dy = self.status.handleSpeed
    }
}