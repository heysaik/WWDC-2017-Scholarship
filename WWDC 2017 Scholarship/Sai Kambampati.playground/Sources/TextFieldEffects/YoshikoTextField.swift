import UIKit

@IBDesignable open class CustomTextField: TextFieldEffects {
    
    private let borderLayer = CALayer()
    private let textFieldInsets = CGPoint(x: 6, y: 0)
    private let placeHolderInsets = CGPoint(x: 6, y: 0)
    
    @IBInspectable open var borderSize: CGFloat = 2.0 {
        didSet {
            updateBorder()
        }
    }
    
    @IBInspectable dynamic open var activeBorderColor: UIColor = .clear {
        didSet {
            updateBorder()
            updateBackground()
            updatePlaceholder()
        }
    }
    
    @IBInspectable dynamic open var inactiveBorderColor: UIColor = .clear {
        didSet {
            updateBorder()
            updateBackground()
            updatePlaceholder()
        }
    }
    
    @IBInspectable dynamic open var activeBackgroundColor: UIColor = .clear {
        didSet {
            updateBackground()
        }
    }
    
    @IBInspectable dynamic open var placeholderColor: UIColor = .darkGray {
        didSet {
            updatePlaceholder()
        }
    }
    
    @IBInspectable dynamic open var placeholderFontScale: CGFloat = 0.7 {
        didSet {
            updatePlaceholder()
        }
    }
    
    override open var placeholder: String? {
        didSet {
            updatePlaceholder()
        }
    }
    
    private func updateBorder() {
        borderLayer.frame = rectForBounds(bounds)
        borderLayer.borderWidth = borderSize
        borderLayer.borderColor = (isFirstResponder || text!.isNotEmpty) ? activeBorderColor.cgColor : inactiveBorderColor.cgColor
    }
    
    private func updateBackground() {
        if isFirstResponder || text!.isNotEmpty {
            borderLayer.backgroundColor = activeBackgroundColor.cgColor
        } else {
            borderLayer.backgroundColor = inactiveBorderColor.cgColor
        }
    }
    
    private func updatePlaceholder() {
        placeholderLabel.frame = placeholderRect(forBounds: bounds)
        placeholderLabel.text = placeholder
        placeholderLabel.textAlignment = textAlignment
        
        if isFirstResponder || text!.isNotEmpty {
            placeholderLabel.font = placeholderFontFromFontAndPercentageOfOriginalSize(font: font!, percentageOfOriginalSize: placeholderFontScale * 0.8)
            placeholderLabel.text = placeholder?.uppercased()
            placeholderLabel.textColor = activeBorderColor
        } else {
            placeholderLabel.font = placeholderFontFromFontAndPercentageOfOriginalSize(font: font!, percentageOfOriginalSize: placeholderFontScale)
            placeholderLabel.textColor = placeholderColor
        }
    }
    
    private func placeholderFontFromFontAndPercentageOfOriginalSize(font: UIFont, percentageOfOriginalSize: CGFloat) -> UIFont! {
        let smallerFont = UIFont(name: font.fontName, size: font.pointSize * percentageOfOriginalSize)
        return smallerFont
    }
    
    private func rectForBounds(_ bounds: CGRect) -> CGRect {
        return CGRect(x: bounds.origin.x, y: bounds.origin.y + placeholderHeight, width: bounds.size.width, height: bounds.size.height - placeholderHeight)
    }
    
    private var placeholderHeight : CGFloat {
        return placeHolderInsets.y + placeholderFontFromFontAndPercentageOfOriginalSize(font: font!, percentageOfOriginalSize: placeholderFontScale).lineHeight
    }
    
    private func animateViews() {
        UIView.animate(withDuration: 0.2, animations: {
            if self.text!.isEmpty {
                self.placeholderLabel.alpha = 0
            }
            self.placeholderLabel.frame = self.placeholderRect(forBounds: self.bounds)
        }) { _ in
            self.updatePlaceholder()
            UIView.animate(withDuration: 0.3, animations: {
                self.placeholderLabel.alpha = 1
                self.updateBorder()
                self.updateBackground()
            }, completion: { _ in
                self.animationCompletionHandler?(self.isFirstResponder ? .textEntry : .textDisplay)
            })
        }
    }
    
    override open func animateViewsForTextEntry() {
        animateViews()
    }
    
    override open func animateViewsForTextDisplay() {
        animateViews()
    }
    
    override open var bounds: CGRect {
        didSet {
            updatePlaceholder()
            updateBorder()
            updateBackground()
        }
    }
    
    override open func drawViewsForRect(_ rect: CGRect) {
        updatePlaceholder()
        updateBorder()
        updateBackground()
        
        layer.addSublayer(borderLayer)
        addSubview(placeholderLabel)
    }
    
    open override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        if isFirstResponder || text!.isNotEmpty {
            return CGRect(x: placeHolderInsets.x, y: placeHolderInsets.y, width: bounds.width, height: placeholderHeight)
        } else {
            return textRect(forBounds: bounds)
        }
    }
    
    open override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
    
    override open func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.offsetBy(dx: textFieldInsets.x, dy: textFieldInsets.y + placeholderHeight / 2)
    }
    
    open override func prepareForInterfaceBuilder() {
        placeholderLabel.alpha = 1
    }
}
