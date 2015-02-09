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
    var zRotation:CGFloat
}

class RouletteSoundObject : SoundObject, ModulatorNode
{
    override var gridHeight:CGFloat { get { return 2 } }
    override var gridWidth:CGFloat { get { return 2 } }

    var rouletteSpin:RouletteSpin?
    var rouletteButton:RouletteButton?
    var rouletteFrame:RouletteFrame?

    let rouletteBackgroundTexture:SKTexture = SKTexture(imageNamed: "roulette_background.png")
    let rouletteEditTexture:SKTexture = SKTexture(imageNamed: "roulette.png")

    var modulators:Array<Modulator> = Array<Modulator>()
    var status:RouletteStatus = RouletteStatus(angularVelocity: CGFloat(0), buttonToggled:false, zRotation:0)
    var savedStatus : Array<RouletteStatus> = Array<RouletteStatus>(count: 4, repeatedValue: RouletteStatus(angularVelocity: CGFloat(0), buttonToggled:false, zRotation:0))
    
    var touchedSpin:Bool = false
    
    override init()
    {
        super.init()
    }
    
    override init(texture: SKTexture!, color: UIColor!, size: CGSize)
    {
        super.init(texture: rouletteEditTexture, color: color, size: size)
        self.iconImageName = "roulette_icon.png"
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        self.savedStatus[0].angularVelocity = CGFloat(aDecoder.decodeFloatForKey("angularVelocity0"))
        self.savedStatus[1].angularVelocity = CGFloat(aDecoder.decodeFloatForKey("angularVelocity1"))
        self.savedStatus[2].angularVelocity = CGFloat(aDecoder.decodeFloatForKey("angularVelocity2"))
        self.savedStatus[3].angularVelocity = CGFloat(aDecoder.decodeFloatForKey("angularVelocity3"))
        
        self.savedStatus[0].zRotation = CGFloat(aDecoder.decodeFloatForKey("zRotation0"))
        self.savedStatus[1].zRotation = CGFloat(aDecoder.decodeFloatForKey("zRotation1"))
        self.savedStatus[2].zRotation = CGFloat(aDecoder.decodeFloatForKey("zRotation2"))
        self.savedStatus[3].zRotation = CGFloat(aDecoder.decodeFloatForKey("zRotation3"))
        
        self.savedStatus[0].buttonToggled = Bool(aDecoder.decodeBoolForKey("buttonToggled0"))
        self.savedStatus[1].buttonToggled = Bool(aDecoder.decodeBoolForKey("buttonToggled1"))
        self.savedStatus[2].buttonToggled = Bool(aDecoder.decodeBoolForKey("buttonToggled2"))
        self.savedStatus[3].buttonToggled = Bool(aDecoder.decodeBoolForKey("buttonToggled3"))
    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
        aCoder.encodeFloat(Float(self.savedStatus[0].angularVelocity), forKey: "angularVelocity0")
        aCoder.encodeFloat(Float(self.savedStatus[1].angularVelocity), forKey: "angularVelocity1")
        aCoder.encodeFloat(Float(self.savedStatus[2].angularVelocity), forKey: "angularVelocity2")
        aCoder.encodeFloat(Float(self.savedStatus[3].angularVelocity), forKey: "angularVelocity3")
        
        aCoder.encodeFloat(Float(self.savedStatus[0].zRotation), forKey: "zRotation0")
        aCoder.encodeFloat(Float(self.savedStatus[1].zRotation), forKey: "zRotation1")
        aCoder.encodeFloat(Float(self.savedStatus[2].zRotation), forKey: "zRotation2")
        aCoder.encodeFloat(Float(self.savedStatus[3].zRotation), forKey: "zRotation3")
        
        aCoder.encodeBool(self.savedStatus[0].buttonToggled, forKey: "buttonToggled0")
        aCoder.encodeBool(self.savedStatus[1].buttonToggled, forKey: "buttonToggled1")
        aCoder.encodeBool(self.savedStatus[2].buttonToggled, forKey: "buttonToggled2")
        aCoder.encodeBool(self.savedStatus[3].buttonToggled, forKey: "buttonToggled3")
    }
    
    override init(gridSize:CGFloat) {
        super.init(gridSize:gridSize)
    }
    
    override func startPhysicalBody() {
        if (self.rouletteSpin != nil) {
            rouletteSpin!.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width / 2)
            rouletteSpin!.physicsBody?.dynamic = true
            rouletteSpin!.physicsBody?.allowsRotation = true
            rouletteSpin!.physicsBody?.mass = 1
            rouletteSpin!.physicsBody?.angularDamping = 0.2
        }
    }
    
    func loadSpin()
    {
        self.zPosition = -1
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
        self.rouletteButton!.size.width = self.size.width / 2.4
        self.rouletteButton!.size.height = self.size.height / 2.4
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
            touchedSpin = true
            self.rouletteSpin!.touchStarted(position)
        }
    }
    
    override func touchEnded(position:CGPoint)
    {
        touchedSpin = false
        if (self.rouletteSpin != nil) {
            self.rouletteSpin!.touchEnded(position)
        }
    }
    
    override func touchCancelled(position:CGPoint)
    {
        var convertedPoint = self.scene!.convertPoint(position, toNode:self)
        if (!self.containsPoint(convertedPoint)) {
            if (self.rouletteSpin != nil) {
                self.rouletteSpin!.touchCancelled(position)
            }
        }
        else {
            touchedSpin = false
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
        result.savedStatus = self.savedStatus
        return result
    }
    
    override func saveStatus(slot:Int)
    {
        self.status.angularVelocity = self.rouletteSpin!.physicsBody!.angularVelocity
        self.status.zRotation = self.rouletteSpin!.zRotation
        self.status.buttonToggled = self.rouletteButton!.toggled
        self.savedStatus[slot] = self.status;
    }
    override func loadStatus(slot:Int)
    {
        self.status = self.savedStatus[slot];
        self.rouletteSpin!.physicsBody!.angularVelocity = self.status.angularVelocity
        self.rouletteSpin!.zRotation = self.status.zRotation
        self.rouletteButton!.setToggle(self.status.buttonToggled)
    }
}