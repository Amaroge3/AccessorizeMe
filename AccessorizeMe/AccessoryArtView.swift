//
//  AccessoryArtView.swift
//  AccessorizeMe
//
//  Created by Andi Maroge on 1/10/19.
//  Copyright © 2019 Andi Maroge. All rights reserved.
//

import UIKit

class AccessoryArtView: UIView, UIDropInteractionDelegate {
    
    
    
    override init (frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    required init?(coder aDecoder: NSCoder){
        super.init(coder: aDecoder)
        setup()
    }
    private func setup() {
        addInteraction(UIDropInteraction(delegate: self))
        
    }
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: UIImage.self)
        
    }
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        return UIDropProposal(operation: .copy)
    }
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        session.loadObjects(ofClass: UIImage.self) { providers in
            let dropPoint = session.location(in: self)
            for image in providers as? [UIImage] ?? [] {
                var imageView = UIImageView()
                imageView.frame.size = image.size
                imageView.image = image
                imageView.center = dropPoint
                self.addSubview(imageView)
            }
            
        }
    }
    
    
    
    var backgroundImage: UIImage? {
        didSet { setNeedsDisplay() }
    }
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        backgroundImage?.draw(in: bounds)
    }
    

}
