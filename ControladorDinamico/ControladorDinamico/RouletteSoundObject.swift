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
    override var imageName:String { get { return "roulette.png" } }
    
    var rouletteSpinImageName:String { get { return "roulette_spinningpart.png" } }
    var rouletteBackgroundImageName:String { get { return "roulette_background.png" } }
    
    var rouletteSpin:RouletteSpin?
    var rouletteSpinTexture:SKTexture?
    var rouletteBackgroundTexture:SKTexture?
    
    var modulators:Array<Modulator> = Array<Modulator>()
    
    override init()
    {
        super.init()
    }
    
    override init(texture: SKTexture!, color: UIColor!, size: CGSize)
    {
        super.init(texture: texture, color: color, size: size)
        self.loadTextures()
        self.loadHandle()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        self.texture = self.rouletteBackgroundTexture
    }
    
    override init(gridSize:CGFloat) {
        super.init(gridSize:gridSize)
        self.texture = self.rouletteBackgroundTexture
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
        
        for obj in self.children {
            let rouletteSpin:RouletteSpin = obj as RouletteSpin
            self.rouletteSpin = rouletteSpin
            rouletteSpin.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width / 2, center: CGPoint(x:self.size.width / 2 , y:self.size.height / 2))
            rouletteSpin.physicsBody?.categoryBitMask = (1 << 3)
            rouletteSpin.physicsBody?.contactTestBitMask = 0
            rouletteSpin.physicsBody?.collisionBitMask = 0
            rouletteSpin.physicsBody?.dynamic = true
            rouletteSpin.physicsBody?.mass = 1
            rouletteSpin.physicsBody?.allowsRotation = true
            rouletteSpin.physicsBody?.friction = 0.9
            rouletteSpin.physicsBody?.restitution = 0
            rouletteSpin.physicsBody?.linearDamping = 0.9
            rouletteSpin.physicsBody?.angularDamping = 0.9

        }
    }
    
    func loadHandle()
    {
        self.removeAllChildren()
        self.rouletteSpin = RouletteSpin(texture: self.rouletteSpinTexture)
        self.rouletteSpin!.anchorPoint = CGPoint(x: 0, y: 0)
        
        self.rouletteSpin!.size.width = 0
        self.rouletteSpin!.size.height = 0
        self.rouletteSpin!.position.x = 0;
        self.rouletteSpin!.position.y = 0;
        
        self.addChild(self.rouletteSpin!);
    }
    
    func loadTextures() {
        self.rouletteSpinTexture = SKTexture(imageNamed: self.rouletteSpinImageName);
        self.rouletteBackgroundTexture = SKTexture(imageNamed: self.rouletteBackgroundImageName);
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
        self.rouletteSpin!.size.width = self.size.width
        self.rouletteSpin!.size.height = self.size.height
        self.rouletteSpin!.position.x = 0
        self.rouletteSpin!.position.y = 0
    }

}