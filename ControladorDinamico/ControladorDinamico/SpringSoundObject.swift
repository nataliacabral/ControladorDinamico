//
//  SpringSoundObject.swift
//  ControladorDinamico
//
//  Created by Natália Cabral on 12/11/14.
//  Copyright (c) 2014 Natália Cabral. All rights reserved.
//

import Foundation
import SpriteKit

class SpringSoundObject : SoundObject, Touchable, ModulatorNode
{
    override var gridHeight:CGFloat { get { return 3 } }
    override var gridWidth:CGFloat { get { return 1 } }
    override var templateImageName:String { get { return "spring.png" } }
    
    var sticksList:Array<SKSpriteNode> = Array<SKSpriteNode>()
    var springHandle:SpringHandle?
    let springTrackTexture:SKTexture = SKTexture(imageNamed: "spring_background.png")
    
    let handlerWidthBorder:CGFloat = 3.5
    let stickWidthBorder:CGFloat = 10

    var modulators:Array<Modulator> = Array<Modulator>()
    var springJoint:SKPhysicsJointSpring?
    
    override init()
    {
        super.init()
    }
    
    override init(texture: SKTexture!, color: UIColor!, size: CGSize)
    {
        super.init(texture: texture, color: color, size: size)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
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
            self.springHandle!.size.width = self.size.width - (self.handlerWidthBorder * 2)
            let ratio:CGFloat = self.springHandle!.texture!.size().width / self.springHandle!.size.width
            self.springHandle!.size.height = self.springHandle!.texture!.size().height / ratio
            self.springHandle!.position.x = 0;
            self.springHandle!.position.y = self.size.height / 4;
            
            self.addChild(self.springHandle!);
        }
        
        for stickIndex in 0...10
        {
            var stick:SKSpriteNode = SKSpriteNode(imageNamed: "spring_stick.png")
            stick.size.width = self.size.width - (self.stickWidthBorder * 2)
            stick.size.height = self.springHandle!.size.height / 8
            stick.position.x = 0;
            stick.position.y = 0;
            self.sticksList.append(stick)
            self.addChild(stick);
        }
        self.updateSticksPosition()

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
            let range:CGFloat = (self.size.height / 2) - handlePosition - handleSize
            let distance:CGFloat = range / CGFloat(self.sticksList.count)
            var currentPosition:CGFloat = (self.size.height / 2) - self.stickWidthBorder

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
        self.physicsBody!.categoryBitMask = 3
        self.physicsBody!.contactTestBitMask = 3
        self.physicsBody!.collisionBitMask = 3
        self.physicsBody!.dynamic = false
        self.physicsBody!.restitution = 0.5
        
        springHandle!.physicsBody = SKPhysicsBody(rectangleOfSize: springHandle!.size)
        springHandle!.physicsBody?.collisionBitMask = 3
        springHandle!.physicsBody?.categoryBitMask = 3
        springHandle!.physicsBody?.contactTestBitMask = 3
        springHandle!.physicsBody?.dynamic = true
        springHandle!.physicsBody?.restitution = 0.5
        springHandle!.physicsBody?.linearDamping = 0
        springHandle!.physicsBody?.allowsRotation = false
        springHandle!.physicsBody?.affectedByGravity = false

        let positionY:CGFloat = self.position.y - self.size.height / 2
        let springHandleAnchor = self.convertPoint(self.springHandle!.position, toNode: self.scene!)
        self.springJoint = SKPhysicsJointSpring .jointWithBodyA(self.springHandle!.physicsBody!, bodyB:self.physicsBody!, anchorA:CGPoint(x: self.position.x, y: positionY) , anchorB:springHandleAnchor)
        
        springJoint!.frequency = 0.4;
        springJoint!.damping = 0.05;
        self.scene?.physicsWorld .addJoint(springJoint!)
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
        return result
    }
}