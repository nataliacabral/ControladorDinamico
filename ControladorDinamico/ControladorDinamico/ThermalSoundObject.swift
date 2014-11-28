//
//  ThermalSoundObject.swift
//  ControladorDinamico
//
//  Created by Natália Cabral on 12/11/14.
//  Copyright (c) 2014 Natália Cabral. All rights reserved.
//

import Foundation
import SpriteKit

class ThermalSoundObject : SoundObject
{
    override var gridHeight:CGFloat { get { return 2 } }
    override var gridWidth:CGFloat { get { return 2 } }
    override var templateImageName:String { get { return "thermal.png" } }
    
    var frames:Array<ThermalFrame> = Array<ThermalFrame>()
    let thermalBackgroundTexture:SKTexture = SKTexture(imageNamed: "thermal_background.png")
    let thermalFrameBorder:CGFloat = 5

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
    
    func loadFrames()
    {
        for i in 0...3
        {
            let frameWidthWithBorder:CGFloat = self.size.width / 2
            let frameHeigthWithBorder:CGFloat = self.size.height / 2

            var frame:ThermalFrame = ThermalFrame()
            frame.size.width = frameWidthWithBorder - thermalFrameBorder * 2
            frame.size.height = frameHeigthWithBorder - thermalFrameBorder * 2
            frame.position.x = -frameWidthWithBorder / 2
            frame.position.y = -frameHeigthWithBorder / 2
           
            if (i == 1 || i == 3) {
                frame.position.x =  frame.position.x + frameWidthWithBorder
            }
            
            if (i == 2 || i == 3) {
                frame.position.y =  frame.position.y + frameHeigthWithBorder
            }
            self.frames.append(frame);
            self.addChild(frame);
        }
        
        
    }
    
    override func update(currentTime: NSTimeInterval)
    {
        for frame in self.frames
        {
            frame.update(currentTime)
        }
    }
    
    override func playObject() -> SoundObject
    {
        var result:ThermalSoundObject = ThermalSoundObject(
            texture:self.texture,
            color:self.color,
            size:self.size
        )
        result.texture = thermalBackgroundTexture
        result.position = self.position
        result.loadFrames()
        return result
    }

}