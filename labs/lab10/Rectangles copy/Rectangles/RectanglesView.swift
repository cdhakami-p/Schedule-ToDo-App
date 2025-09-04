//
//  RectanglesView.swift
//  Rectangles
//
//  Created by Rockwell, Jarret M on 4/15/25.
//

import UIKit

class RectanglesView: UIView {
    
    override func draw(_ rect: CGRect) {
        
        let myFirstPath = UIBezierPath()
        
        myFirstPath.lineWidth = 5
        
        let myBounds = self.bounds
        
        var circleCenter = CGPoint()
        circleCenter.x = myBounds.midX
        circleCenter.y = myBounds.midY
        
        //let minOfTwoSizes: CGFloat = min(myBounds.size.width, myBounds.size.height)
        
        myFirstPath.addArc(withCenter: circleCenter,
                           radius: 20,
                           startAngle: 0,
                           endAngle: 6.28,
                           clockwise: true)
        
        myFirstPath.stroke()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
