//
//  CircularProgressView.swift
//  Retail-Agent
//
//  Created by Moin Ul Hassan, Muhammad on 20/09/2019.
//  Copyright © 2019 Moin Ul Hassan, Muhammad. All rights reserved.
//

import Foundation
import UIKit

public class CircularProgressView: UIView {
    
    //MARK: - Properties
    public var startAngle: CGFloat = 150
    public var endAngle: CGFloat = 320
    
    public let progressLayer = CAShapeLayer()
    public let staticLayer = CAShapeLayer()
    
    public var strokeColor: UIColor = UIColor.orange
    
    //MARK: - Outlets
    @IBOutlet weak var progressView: UIView!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var recommendationType: UILabel!
    @IBOutlet weak var rcmdValue: UILabel!
    @IBOutlet weak var rcmdSubValue: UILabel!
    
    //MARK: - Init methods
    public override init(frame: CGRect) {
        super.init(frame: frame)
        xibSetUp()
    }
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        xibSetUp()
        
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
    }
    
    //MARK: - Helper Methods
    public func initValues(strokeColor: UIColor, percentageVal: CGFloat, recommendationType: String, rcmdValue: Double = 25.5, rcmdSubValue: String = "42 Sold") {
        
        self.strokeColor = strokeColor
        
        //map percentage value to end angle here
        let endAngle = (abs(percentageVal) * 240) + self.startAngle
        
        self.endAngle =  endAngle <= 390 ? endAngle : 200
        
        self.recommendationType.text = recommendationType
        self.rcmdValue.text = formatRcmdPriceVal(rcmdValue: rcmdValue)
        self.rcmdSubValue.text = rcmdSubValue
        
        self.animateProgCircle()
    }
    
    func formatRcmdPriceVal(rcmdValue: Double) -> String {
        let currencyFormatter = NumberFormatter()
        
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        
        let stringValue = String(describing: rcmdValue).components(separatedBy: ".")[0]
        
        let maxFractionDigits = 6 - stringValue.count

        currencyFormatter.maximumFractionDigits = maxFractionDigits

        let value = currencyFormatter.string(from: NSNumber(floatLiteral: rcmdValue))!
        
        return value
    }
    
    public func xibSetUp() {
        let bundle = Bundle(for: CircularProgressView.self)
        bundle.loadNibNamed("CircularProgressView", owner: self, options: nil)
        
        
        //Bundle.main.loadNibNamed("CircularProgressView", owner: self, options: nil)
        
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
    }
    
    public func animateProgCircle() {
        self.layoutIfNeeded()
        self.progressView.layoutIfNeeded()
        
        let startAngle = (self.startAngle * CGFloat.pi) / 180
        let endAngle = (self.endAngle * CGFloat.pi) / 180
        
        let radius = self.progressView.frame.width / 2
        
        let center = self.progressView.center
        
        //path to render static gray circle
        let staticPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: (30.0 * CGFloat.pi) / 180, clockwise: true)
        
        staticLayer.path = staticPath.cgPath
        
        staticLayer.fillColor = UIColor.clear.cgColor
        staticLayer.strokeColor = UIColor.gray.cgColor
        
        staticLayer.lineWidth = 5.0
        staticLayer.strokeEnd = 0
        
        self.layer.addSublayer(staticLayer)
        
         //path to render dynamic circle filled with color
        let circularPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        progressLayer.path = circularPath.cgPath
        
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeColor = self.strokeColor.cgColor
        progressLayer.lineWidth = 5.0
        progressLayer.strokeEnd = 0
        
        self.layer.addSublayer(progressLayer)
        
        startAnimation()
        
    }
    
    public func startAnimation() {
        let basicAnimation = CABasicAnimation(keyPath: "strokeEnd")
        
        basicAnimation.toValue = 1.0
        basicAnimation.duration = 1.5
        
        basicAnimation.fillMode = .forwards
        basicAnimation.isRemovedOnCompletion = false
        
        progressLayer.add(basicAnimation, forKey: "basicAnimation")
        staticLayer.add(basicAnimation, forKey: "basicAnimation")
    }
}
