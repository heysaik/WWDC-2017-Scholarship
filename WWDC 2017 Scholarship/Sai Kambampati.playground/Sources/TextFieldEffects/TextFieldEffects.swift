import UIKit

extension String {
    public var isNotEmpty: Bool {
        return !isEmpty
    }
}

open class TextFieldEffects : UITextField {
    public enum AnimationType: Int {
        case textEntry
        case textDisplay
    }
    
    public typealias AnimationCompletionHandler = (_ type: AnimationType)->()
    
    open let placeholderLabel = UILabel()
    
    open func animateViewsForTextEntry() {
        fatalError("\(#function) must be overridden")
    }
    
    open func animateViewsForTextDisplay() {
        fatalError("\(#function) must be overridden")
    }
    
    open var animationCompletionHandler: AnimationCompletionHandler?
    
    open func drawViewsForRect(_ rect: CGRect) {
        fatalError("\(#function) must be overridden")
    }
    
    open func updateViewsForBoundsChange(_ bounds: CGRect) {
        fatalError("\(#function) must be overridden")
    }
    
    // MARK: Overrides
    override open func draw(_ rect: CGRect) {
        drawViewsForRect(rect)
    }
    
    override open func drawPlaceholder(in rect: CGRect) {

    }
    
    override open var text: String? {
        didSet {
            if let text = text, text.isNotEmpty {
                animateViewsForTextEntry()
            } else {
                animateViewsForTextDisplay()
            }
        }
    }
    
    // MARK: UITextField Observing
    override open func willMove(toSuperview newSuperview: UIView!) {
        if newSuperview != nil {
            NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidEndEditing), name: NSNotification.Name.UITextFieldTextDidEndEditing, object: self)
            
            NotificationCenter.default.addObserver(self, selector: #selector(textFieldDidBeginEditing), name: NSNotification.Name.UITextFieldTextDidBeginEditing, object: self)
        } else {
            NotificationCenter.default.removeObserver(self)
        }
    }
    
    open func textFieldDidBeginEditing() {
        animateViewsForTextEntry()
    }
    
    open func textFieldDidEndEditing() {
        animateViewsForTextDisplay()
    }
    
    // MARK: Interface Builder
    override open func prepareForInterfaceBuilder() {
        drawViewsForRect(frame)
    }
}
