//
//  ThermalSoundObject.swift
//  ControladorDinamico
//
//  Created by Natália Cabral on 12/11/14.
//  Copyright (c) 2014 Natália Cabral. All rights reserved.
//

import Foundation
import SpriteKit

struct ThermalStatus
{
    var alphaQ1:CGFloat
    var alphaQ2:CGFloat
    var alphaQ3:CGFloat
    var alphaQ4:CGFloat
}

class ThermalSoundObject : SoundObject
{
    override var gridHeight:CGFloat { get { return 2 } }
    override var gridWidth:CGFloat { get { return 2 } }
    override var templateImageName:String { get { return "thermal.png" } }
    
    var frames:Array<ThermalFrame> = Array<ThermalFrame>()
    let thermalBackgroundTexture:SKTexture = SKTexture(imageNamed: "thermal_background.png")
    let thermalFrameBorder:CGFloat = 5
    
    var status:ThermalStatus = ThermalStatus(alphaQ1: CGFloat(0.0), alphaQ2: CGFloat(0.0), alphaQ3: CGFloat(0.0), alphaQ4: CGFloat(0.0))
    var savedStatus : Array<ThermalStatus> = Array<ThermalStatus>(count: 4, repeatedValue:
        ThermalStatus(alphaQ1: CGFloat(0.0), alphaQ2: CGFloat(0.0), alphaQ3: CGFloat(0.0), alphaQ4: CGFloat(0.0)))

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
    
    
    override func saveStatus(slot:Int)
    {
        self.status.alphaQ1 = self.frames[0].alpha
        self.status.alphaQ2 = self.frames[1].alpha
        self.status.alphaQ3 = self.frames[2].alpha
        self.status.alphaQ4 = self.frames[3].alpha
        self.savedStatus[slot] = self.status;
    }
    
    override func loadStatus(slot:Int)
    {
        self.status = self.savedStatus[slot];
        self.frames[0].alpha = self.status.alphaQ1
        self.frames[1].alpha = self.status.alphaQ2
        self.frames[2].alpha = self.status.alphaQ3
        self.frames[3].alpha = self.status.alphaQ4
    }

}