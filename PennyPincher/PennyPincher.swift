import CoreGraphics

open class PennyPincher {
    
    fileprivate static let NumResamplingPoints = 16
    
    public init() {
        
    }
    
    open class func createTemplate(_ id: String, points: [CGPoint]) -> PennyPincherTemplate? {
        if points.count == 0 {
            return nil
        }
        
        return PennyPincherTemplate(id: id, points: PennyPincher.resampleBetweenPoints(points))
    }
    
    open class func recognize(_ points: [CGPoint], templates: [PennyPincherTemplate]) -> (template: PennyPincherTemplate, similarity: CGFloat)? {
        if points.count == 0 || templates.count == 0 {
            return nil
        }
        
        let c = PennyPincher.resampleBetweenPoints(points)
        
        if c.count == 0 {
            return nil
        }
        
        var similarity = CGFloat.leastNormalMagnitude
        var t: PennyPincherTemplate!
        var d: CGFloat
        
        for template in templates {
            d = 0.0
            
            let count = min(c.count, template.points.count)
            
            for i in 0...count - 1 {
                let tp = template.points[i]
                let cp = c[i]
                
                d = d + tp.x * cp.x + tp.y * cp.y
                
                if d > similarity {
                    similarity = d
                    t = template
                }
            }
        }
        
        if t == nil {
            return nil
        }
        
        return (t, similarity)
    }
    
    fileprivate class func resampleBetweenPoints(_ p: [CGPoint]) -> [CGPoint] {
        var points = p
        let i = pathLength(points) / CGFloat(PennyPincher.NumResamplingPoints - 1)
        var d: CGFloat = 0.0
        var v = [CGPoint]()
        var prev = points.first!
        
        var index = 0
        for _ in points {
            
            if index == 0 {
                index += 1
                continue
            }
            
            let thisPoint = points[index]
            let prevPoint = points[index - 1]
            
            let pd = distanceBetweenPoint(thisPoint, andPoint: prevPoint)
            
            if (d + pd) >= i {
                let q = CGPoint(
                    x: prevPoint.x + (thisPoint.x - prevPoint.x) * (i - d) / pd,
                    y: prevPoint.y + (thisPoint.y - prevPoint.y) * (i - d) / pd
                )
                
                var r = CGPoint(x: q.x - prev.x, y: q.y - prev.y)
                let rd = distanceBetweenPoint(CGPoint.zero, andPoint: r)
                r.x = r.x / rd
                r.y = r.y / rd
                
                d = 0.0
                prev = q
                
                v.append(r)
                points.insert(q, at: index)
                index += 1
            } else {
                d = d + pd
            }
            
            index += 1
        }
        
        return v
    }
    
    fileprivate class func pathLength(_ points: [CGPoint]) -> CGFloat {
        var d: CGFloat = 0.0
        
        for i in 1..<points.count {
            d = d + distanceBetweenPoint(points[i - 1], andPoint: points[i])
        }
        
        return d
    }
    
    fileprivate class func distanceBetweenPoint(_ pointA: CGPoint, andPoint pointB: CGPoint) -> CGFloat {
        let distX = pointA.x - pointB.x
        let distY = pointA.y - pointB.y
        
        return sqrt((distX * distX) + (distY * distY))
    }
    
}
