import UIKit

public protocol HolderViewDelegate:class {
    func animateLabel()
}

public class HolderView: UIView {
    let ovalLayer = OvalLayer()
    let triangleLayer = TriangleLayer()
    let redRectangleLayer = RectangleLayer()
    let blueRectangleLayer = RectangleLayer()
    let arcLayer = ArcLayer()
    public var parentFrame :CGRect = CGRect.zero
    public var delegate:HolderViewDelegate?
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = Colors.clear
    }
    
    public required init(coder: NSCoder) {
        super.init(coder: coder)!
    }
    
    public func addOval() {
        layer.addSublayer(ovalLayer)
        ovalLayer.expand()
        Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(HolderView.wobbleOval),
                             userInfo: nil, repeats: false)
    }
    
    func wobbleOval() {
        layer.addSublayer(triangleLayer)
        ovalLayer.wobble()
        Timer.scheduledTimer(timeInterval: 0.9, target: self, selector: #selector(HolderView.drawAnimatedTriangle), userInfo: nil, repeats: false)
    }
    
    func drawAnimatedTriangle() {
        triangleLayer.animate()
        Timer.scheduledTimer(timeInterval: 0.9, target: self, selector: #selector(HolderView.spinAndTransform),
                             userInfo: nil, repeats: false)
    }
    
    func spinAndTransform() {
        layer.anchorPoint = CGPoint(x: 0.5, y: 0.6)
        let rotationAnimation: CABasicAnimation = CABasicAnimation(keyPath: "transform.rotation.z")
        rotationAnimation.toValue = CGFloat(Double.pi * 2.0)
        rotationAnimation.duration = 0.45
        rotationAnimation.isRemovedOnCompletion = true
        layer.add(rotationAnimation, forKey: nil)
        
        ovalLayer.contract()
        Timer.scheduledTimer(timeInterval: 0.45, target: self, selector: #selector(HolderView.drawRedAnimatedRectangle), userInfo: nil, repeats: false)
        Timer.scheduledTimer(timeInterval: 0.65, target: self, selector: #selector(HolderView.drawBlueAnimatedRectangle), userInfo: nil, repeats: false)
    }
    
    func drawRedAnimatedRectangle() {
        layer.addSublayer(redRectangleLayer)
        redRectangleLayer.animateStrokeWithColor(color: Colors.red)
    }
    
    func drawBlueAnimatedRectangle() {
        layer.addSublayer(blueRectangleLayer)
        blueRectangleLayer.animateStrokeWithColor(color: Colors.blue)
        Timer.scheduledTimer(timeInterval: 0.40, target: self, selector: #selector(HolderView.drawArc),
                             userInfo: nil, repeats: false)
    }
    
    func drawArc() {
        layer.addSublayer(arcLayer)
        arcLayer.animate()
        Timer.scheduledTimer(timeInterval: 0.90, target: self, selector: #selector(HolderView.expandView),
                             userInfo: nil, repeats: false)
    }
    
    func expandView() {
        backgroundColor = Colors.blue
        frame = CGRect(x: frame.origin.x - blueRectangleLayer.lineWidth, y: frame.origin.y - blueRectangleLayer.lineWidth, width: frame.size.width + blueRectangleLayer.lineWidth * 2, height: frame.size.height + blueRectangleLayer.lineWidth * 2)
        layer.sublayers = nil
        
        UIView.animate(withDuration: 0.3, delay: 0.0, options: [], animations: {self.frame = self.parentFrame}, completion: { finished in
            self.addLabel()
        })
    }
    
    func addLabel() {
        delegate?.animateLabel()
    }
}
