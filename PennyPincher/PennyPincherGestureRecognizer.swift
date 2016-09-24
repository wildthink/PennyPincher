#if os(iOS)
    import UIKit
    import UIKit.UIGestureRecognizerSubclass 
    public typealias GestureRecognizer = UIGestureRecognizer

#else
    import AppKit
    public typealias GestureRecognizer = NSGestureRecognizer
#endif

open class PennyPincherGestureRecognizer: GestureRecognizer {
    
    open var enableMultipleStrokes: Bool = true
    open var allowedTimeBetweenMultipleStrokes: TimeInterval = 0.2
    open var templates = [PennyPincherTemplate]()
    
    fileprivate(set) open var result: (template: PennyPincherTemplate, similarity: CGFloat)?
    
    fileprivate let pennyPincher = PennyPincher()
    fileprivate var points = [CGPoint]()
    fileprivate var timer: Timer?
    
    open override func reset() {
        super.reset()
       
        invalidateTimer()
        
        points.removeAll(keepingCapacity: false)
        
        result = nil
    }
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        invalidateTimer()
        
        if let touch = touches.first {
            points.append(touch.location(in: view))
        }

        if state == .possible {
            state = .began
        }
    }
    
    override open func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        if let touch = touches.first {
            points.append(touch.location(in: view))
        }
        
        state = .changed
    }
    
    override open func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        if enableMultipleStrokes {
            timer = Timer.scheduledTimer(timeInterval: allowedTimeBetweenMultipleStrokes,
                target: self,
                selector: #selector(timerDidFire(_:)),
                userInfo: nil,
                repeats: false)
        } else {
            recognize()
        }
    }
    
    override open func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        points.removeAll(keepingCapacity: false)
        
        state = .cancelled
    }
    
    fileprivate func recognize() {
        result = PennyPincher.recognize(points, templates: templates)
        
        state = result != nil ? .ended : .failed
    }
    
    func timerDidFire(_ timer: Timer) {
        recognize()
    }
    
    fileprivate func invalidateTimer() {
        timer?.invalidate()
        timer = nil
    }
    
}
