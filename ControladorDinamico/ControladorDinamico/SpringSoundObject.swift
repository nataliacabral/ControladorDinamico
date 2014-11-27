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
    
    func loadHandle()
    {
        self.springHandle = nil
        self.removeAllChildren()
        if (self.springHandle == nil) {
            self.springHandle = SpringHandle()
//            self.springHandle!.anchorPoint = CGPoint(x: 0, y: 0)
            
            self.springHandle!.size.width = 0
            self.springHandle!.size.height = 0
            self.springHandle!.position.x = 0;
            self.springHandle!.position.y = 0;
            
            self.addChild(self.springHandle!);
        }
        
        for stickIndex in 0...7
        {
            var stick:SKSpriteNode = SKSpriteNode(imageNamed: "spring_stick.png")
            //stick.anchorPoint = CGPoint(x: 0, y: 0)
            stick.size.width = 0
            stick.size.height = 0
            stick.position.x = 0;
            stick.position.y = 0;
            self.sticksList.append(stick)
            self.addChild(stick);
        }
    }
    
    override func updateGridSize(gridSize:CGFloat)
    {
        super.updateGridSize(gridSize)
        if (self.springHandle != nil) {
            self.springHandle!.size.width = self.size.width - (self.handlerWidthBorder * 2)
            let ratio:CGFloat = self.springHandle!.texture!.size().width / self.springHandle!.size.width
            self.springHandle!.size.height = self.springHandle!.texture!.size().height / ratio
            self.springHandle!.position.x = 0
            self.springHandle!.position.y = 0
        }
        for stick in self.sticksList
        {
            stick.size.width = self.springHandle!.size.width
            stick.size.height = self.springHandle!.size.height / 4
            stick.position.x = self.springHandle!.position.x
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
            var currentPosition:CGFloat = (self.size.height / 2) - stickHeight

            for stick in self.sticksList {
                stick.position.y = currentPosition
                currentPosition -= distance
            }
        }
    }
    
    override func update(currentTime: NSTimeInterval)
    {
        self.updateSticksPosition()
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