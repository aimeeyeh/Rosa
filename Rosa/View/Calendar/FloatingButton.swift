//
//  FloatingButton.swift
//  Rosa
//
//  Created by Chih-Chen Yeh on 2021/6/7.
//

import Foundation
import LiquidFloatingActionButton

public class CustomCell: LiquidFloatingCell {
    var name: String = "sample"
    
    init(icon: UIImage, name: String) {
        self.name = name
        super.init(icon: icon)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func setupView(_ view: UIView) {
        super.setupView(view)
        let label = UILabel()
        label.text = name
        label.textColor = UIColor.white
        label.font = UIFont(name: "HelveticaNeue-Medium", size: 14)
        label.textAlignment = .right
        addSubview(label)
        label.snp.makeConstraints { make in
            make.left.equalTo(self).offset(-100)
            make.width.equalTo(80)
            make.top.height.equalTo(self)
        }
    }
}

public class CustomDrawingActionButton: LiquidFloatingActionButton {
    
    override public func createPlusLayer(_ frame: CGRect) -> CAShapeLayer {
        
        let plusLayer = CAShapeLayer()
        plusLayer.lineCap = .round
        plusLayer.strokeColor = UIColor.white.cgColor
        plusLayer.lineWidth = 3.0
        
        let width = frame.width
        let height = frame.height
        
        let points = [
            (CGPoint(x: width * 0.25, y: height * 0.35), CGPoint(x: width * 0.75, y: height * 0.35)),
            (CGPoint(x: width * 0.25, y: height * 0.5), CGPoint(x: width * 0.75, y: height * 0.5)),
            (CGPoint(x: width * 0.25, y: height * 0.65), CGPoint(x: width * 0.75, y: height * 0.65))
        ]
        
        let path = UIBezierPath()
        for (start, end) in points {
            path.move(to: start)
            path.addLine(to: end)
        }
        
        plusLayer.path = path.cgPath
        
        return plusLayer
    }
}
