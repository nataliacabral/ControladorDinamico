//
//  SliderHandle.swift
//  ControladorDinamico
//
//  Created by Sergio Sette on 11/16/14.
//  Copyright (c) 2014 Natália Cabral. All rights reserved.
//

import Foundation

import Foundation
import SpriteKit

class SliderHandle : SKSpriteNode, Pannable
{
    override init()
    {
        super.init()
    }
    
    override init(texture: SKTexture!, color: UIColor!, size: CGSize)
    {
        super.init(texture: texture, color: color, size: size)
    }
    
    required init(coder aDecoder: NSCoder) {
       super.init()
    }
    
    func panStarted(position:CGPoint) {

    }
    // BEWARE!!! magic stuff below
    // Palavras de um sabio: "Quanto mais comentarios um metodo tem, maior a probabilidade de ser gambiarra"
    func panMoved(translation:CGPoint) {
        var convertedPoint = self.convertPoint(translation, toNode:self.parent!)
        // Valida se a direcao mudou. Se mudou, paramos o objeto (mudando velocidade vertical para 0)
        if (self.physicsBody?.velocity.dy > 0 && translation.y < 0 ||
            self.physicsBody?.velocity.dy < 0 && translation.y > 0) {
                self.physicsBody?.velocity.dy = 0
        }
        // Aplica impulso no objeto, de acordo com o translation (input do usuario)
        
        // O valor do translation é multiplicado por três. Não mais, não menos.
        // Três Deve ser o número a ser multiplicado, e o número da multiplicação, deve ser três
        // Quatro Não deverá ser multiplicado, nem dois. Mesmo o dois precedendo o três
        // Cinco está fora de questão!
        // Quando o número três for multiplicado, então o impulso será aplicado, fazendo o objeto se mover!!!
        self.physicsBody?.applyImpulse(CGVector(dx: 0, dy: translation.y * 3))
    }
    func panEnded() {
        self.physicsBody?.velocity.dy = 0
    }
}