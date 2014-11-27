//
//  RouletteSoundObject.swift
//  ControladorDinamico
//
//  Created by Natália Cabral on 12/11/14.
//  Copyright (c) 2014 Natália Cabral. All rights reserved.
//

import Foundation
import SpriteKit

struct RouletteStatus
{
    var angularVelocity:CGFloat
    var buttonToggled:Bool
}

class RouletteSoundObject : SoundObject, ModulatorNode
{
    override var gridHeight:CGFloat { get { return 2 } }
    override var gridWidth:CGFloat { get { return 2 } }
    override var templateImageName:String { get { return "roulette.png" } }
    
    var rouletteSpin:RouletteSpin?
    var rouletteButton:RouletteButton?
    var rouletteFrame:RouletteFrame?

    let rouletteBackgroundTexture:SKTexture = SKTexture(imageNamed: "roulette_background.png")
    
    var modulators:Array<Modulator> = Array<Modulator>()
    var status:RouletteStatus = RouletteStatus(angularVelocity: CGFloat(0), buttonToggled:false)
    var savedStatus : Array<RouletteStatus> = Array<RouletteStatus>(count: 4, repeatedValue: RouletteStatus(angularVelocity: CGFloat(0), buttonToggled:false))
    
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
    
    override func startPhysicalBody() {
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: self.frame)
        self.physicsBody?.affectedByGravity = false
        self.physicsBody?.categoryBitMask = 2
        self.physicsBody?.contactTestBitMask = 0
        self.physicsBody?.collisionBitMask = 0
        self.physicsBody?.dynamic = false
        self.physicsBody?.mass = 5000
        self.physicsBody?.restitution = 0
        
        if (self.rouletteSpin != nil) {
            rouletteSpin!.physicsBody?.categoryBitMask = (1 << 3)
            rouletteSpin!.physicsBody?.contactTestBitMask = 0
            rouletteSpin!.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width / 2)
            rouletteSpin!.physicsBody?.dynamic = true
            rouletteSpin!.physicsBody?.mass = 1
            rouletteSpin!.physicsBody?.allowsRotation = true
            rouletteSpin!.physicsBody?.restitution = 0
            rouletteSpin!.physicsBody?.linearDamping = 0.9
            rouletteSpin!.physicsBody?.angularDamping = 0.2
        }
    }
    
    func loadSpin()
    {
        self.removeAllChildren()
        
        self.rouletteSpin = RouletteSpin()
        self.rouletteSpin!.size.width = self.size.width
        self.rouletteSpin!.size.height = self.size.height
        self.rouletteSpin!.position.x = 0
        self.rouletteSpin!.position.y = 0
        
        self.addChild(self.rouletteSpin!)
        
        self.rouletteFrame = RouletteFrame()
        self.rouletteFrame!.size.width = self.rouletteSpin!.size.width
        self.rouletteFrame!.size.height = self.rouletteSpin!.size.height
        self.rouletteFrame!.position.x = 0
        self.rouletteFrame!.position.y = 0
        
        self.addChild(self.rouletteFrame!)
        
        self.rouletteButton = RouletteButton()
        self.rouletteButton!.size.width = self.size.width / 2.5
        self.rouletteButton!.size.height = self.size.height / 2.5
        self.rouletteButton!.position.x = 0
        self.rouletteButton!.position.y = 0
        self.rouletteButton!.colorBlendFactor = 1.0
        self.addChild(self.rouletteButton!)
    }
    
    override func currentSoundIntensity() -> Float
    {
        let radianRotation = Double(self.rouletteSpin!.zRotation) / (2 * M_PI)
        return Float(abs(radianRotation))
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
    
    func toggleFriction(dampened:Bool)
    {
        if (self.rouletteSpin != nil) {
            if (!dampened) {
                self.rouletteSpin!.physicsBody?.angularDamping = 0.2
            } else {
                self.rouletteSpin!.physicsBody?.angularDamping = 0
            }
        }
    }
    
    override func touchStarted(position:CGPoint)
    {
        if (self.rouletteSpin != nil) {
            self.rouletteSpin!.touchStarted(position)
        }
    }
    
    override func touchEnded(position:CGPoint)
    {
        if (self.rouletteSpin != nil) {
            self.rouletteSpin!.touchEnded(position)
        }
    }
    
    override func touchMoved(position:CGPoint)
    {
        if (self.rouletteSpin != nil) {
            self.rouletteSpin!.touchMoved(position)
        }
    }

    override func playObject() -> SoundObject
    {
        var result:RouletteSoundObject = RouletteSoundObject(
            texture:self.texture,
            color:self.color,
            size:self.size
        )
        result.texture = rouletteBackgroundTexture
        result.position = self.position
        result.loadSpin()
        return result
    }
    
    override func saveStatus(slot:Int)
    {
        self.status.angularVelocity = self.rouletteSpin!.physicsBody!.angularVelocity
        self.status.buttonToggled = self.rouletteButton!.toggled
        self.savedStatus[slot] = self.status;
    }
    override func loadStatus(slot:Int)
    {
        self.status = self.savedStatus[slot];
        self.rouletteSpin!.physicsBody!.angularVelocity = self.status.angularVelocity
        self.rouletteButton!.setToggle(self.status.buttonToggled)
    }
}