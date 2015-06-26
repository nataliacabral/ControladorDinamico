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

    var frames:Array<ThermalFrame> = Array<ThermalFrame>()
    let thermalBackgroundTexture:SKTexture = SKTexture(imageNamed: "thermal_background.png")
    let thermalEditTexture:SKTexture = SKTexture(imageNamed: "thermal.png")

    let thermalFrameBorder:CGFloat = 6
    
    var status:ThermalStatus = ThermalStatus(alphaQ1: CGFloat(0.0), alphaQ2: CGFloat(0.0), alphaQ3: CGFloat(0.0), alphaQ4: CGFloat(0.0))
    var savedStatus : Array<ThermalStatus> = Array<ThermalStatus>(count: 4, repeatedValue:
        ThermalStatus(alphaQ1: CGFloat(0.0), alphaQ2: CGFloat(0.0), alphaQ3: CGFloat(0.0), alphaQ4: CGFloat(0.0)))

    override init()
    {
        super.init()
    }
    
    override init(texture: SKTexture!, color: UIColor!, size: CGSize)
    {
        super.init(texture: thermalEditTexture, color: color, size: size)
        self.iconImageName = "thermal_icon.png"
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        self.savedStatus[0].alphaQ1 = CGFloat(aDecoder.decodeFloatForKey("alphaQ10"))
        self.savedStatus[1].alphaQ1 = CGFloat(aDecoder.decodeFloatForKey("alphaQ11"))
        self.savedStatus[2].alphaQ1 = CGFloat(aDecoder.decodeFloatForKey("alphaQ12"))
        self.savedStatus[3].alphaQ1 = CGFloat(aDecoder.decodeFloatForKey("alphaQ13"))
        
        self.savedStatus[0].alphaQ2 = CGFloat(aDecoder.decodeFloatForKey("alphaQ20"))
        self.savedStatus[1].alphaQ2 = CGFloat(aDecoder.decodeFloatForKey("alphaQ21"))
        self.savedStatus[2].alphaQ2 = CGFloat(aDecoder.decodeFloatForKey("alphaQ22"))
        self.savedStatus[3].alphaQ2 = CGFloat(aDecoder.decodeFloatForKey("alphaQ23"))
        
        self.savedStatus[0].alphaQ3 = CGFloat(aDecoder.decodeFloatForKey("alphaQ30"))
        self.savedStatus[1].alphaQ3 = CGFloat(aDecoder.decodeFloatForKey("alphaQ31"))
        self.savedStatus[2].alphaQ3 = CGFloat(aDecoder.decodeFloatForKey("alphaQ32"))
        self.savedStatus[3].alphaQ3 = CGFloat(aDecoder.decodeFloatForKey("alphaQ33"))
        
        self.savedStatus[0].alphaQ4 = CGFloat(aDecoder.decodeFloatForKey("alphaQ40"))
        self.savedStatus[1].alphaQ4 = CGFloat(aDecoder.decodeFloatForKey("alphaQ41"))
        self.savedStatus[2].alphaQ4 = CGFloat(aDecoder.decodeFloatForKey("alphaQ42"))
        self.savedStatus[3].alphaQ4 = CGFloat(aDecoder.decodeFloatForKey("alphaQ43"))

    }
    
    override func encodeWithCoder(aCoder: NSCoder) {
        super.encodeWithCoder(aCoder)
        aCoder.encodeFloat(Float(self.savedStatus[0].alphaQ1), forKey: "alphaQ10")
        aCoder.encodeFloat(Float(self.savedStatus[1].alphaQ1), forKey: "alphaQ11")
        aCoder.encodeFloat(Float(self.savedStatus[2].alphaQ1), forKey: "alphaQ12")
        aCoder.encodeFloat(Float(self.savedStatus[3].alphaQ1), forKey: "alphaQ13")
        
        aCoder.encodeFloat(Float(self.savedStatus[0].alphaQ2), forKey: "alphaQ20")
        aCoder.encodeFloat(Float(self.savedStatus[1].alphaQ2), forKey: "alphaQ21")
        aCoder.encodeFloat(Float(self.savedStatus[2].alphaQ2), forKey: "alphaQ22")
        aCoder.encodeFloat(Float(self.savedStatus[3].alphaQ2), forKey: "alphaQ23")
        
        aCoder.encodeFloat(Float(self.savedStatus[0].alphaQ3), forKey: "alphaQ30")
        aCoder.encodeFloat(Float(self.savedStatus[1].alphaQ3), forKey: "alphaQ31")
        aCoder.encodeFloat(Float(self.savedStatus[2].alphaQ3), forKey: "alphaQ32")
        aCoder.encodeFloat(Float(self.savedStatus[3].alphaQ3), forKey: "alphaQ33")
        
        aCoder.encodeFloat(Float(self.savedStatus[0].alphaQ4), forKey: "alphaQ40")
        aCoder.encodeFloat(Float(self.savedStatus[1].alphaQ4), forKey: "alphaQ41")
        aCoder.encodeFloat(Float(self.savedStatus[2].alphaQ4), forKey: "alphaQ42")
        aCoder.encodeFloat(Float(self.savedStatus[3].alphaQ4), forKey: "alphaQ43")
        
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
            frame.position.x = -frame.size.width / 2 + 2
            frame.position.y = -frame.size.height / 2
           
            if (i == 1 || i == 3) {
                frame.position.x =  frame.position.x + frame.size.width
            }
            
            if (i == 2 || i == 3) {
                frame.position.y =  frame.position.y + frame.size.height
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
        result.savedStatus = self.savedStatus
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