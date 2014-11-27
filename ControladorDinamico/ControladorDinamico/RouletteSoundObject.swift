//
//  RouletteSoundObject.swift
//  ControladorDinamico
//
//  Created by Natália Cabral on 12/11/14.
//  Copyright (c) 2014 Natália Cabral. All rights reserved.
//

import Foundation
import SpriteKit

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
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: CGRect(origin:CGPoint(x:0,y:0), size:self.size))
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
//        self.rouletteSpin!.anchorPoint = CGPoint(x: 0, y: 0)
        
        self.rouletteSpin!.size.width = 0
        self.rouletteSpin!.size.height = 0
        self.rouletteSpin!.position.x = 0
        self.rouletteSpin!.position.y = 0
        
        self.addChild(self.rouletteSpin!)
        
        self.rouletteFrame = RouletteFrame()
//        self.rouletteFrame!.anchorPoint = CGPoint(x: 0, y: 0)
        
        self.rouletteFrame!.size.width = 0
        self.rouletteFrame!.size.height = 0
        self.rouletteFrame!.position.x = 0
        self.rouletteFrame!.position.y = 0
        
        self.addChild(self.rouletteFrame!)
        
        self.rouletteButton = RouletteButton()
//        self.rouletteButton!.anchorPoint = CGPoint(x: 0, y: 0)
        
        self.rouletteButton!.size.width = 0
        self.rouletteButton!.size.height = 0
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
    
    override func updateGridSize(gridSize:CGFloat)
    {
        super.updateGridSize(gridSize)
        if (self.rouletteSpin != nil) {
            self.rouletteSpin!.size.width = self.size.width
            self.rouletteSpin!.size.height = self.size.height
            self.rouletteSpin!.position.x = 0
            self.rouletteSpin!.position.y = 0
        }
        
        if (self.rouletteFrame != nil) {
            self.rouletteFrame!.size.width = self.rouletteSpin!.size.width
            self.rouletteFrame!.size.height = self.rouletteSpin!.size.height
            self.rouletteFrame!.position.x = 0
            self.rouletteFrame!.position.y = 0
        }
        
        if (self.rouletteButton != nil) {
            self.rouletteButton!.size.width = self.size.width / 2.5
            self.rouletteButton!.size.height = self.size.height / 2.5
            self.rouletteButton!.position.x = 0
            self.rouletteButton!.position.y = 0
        }
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
}