import Foundation
import UIKit

public class LineVisualization: UIView {
    
    var lineViews: [UIView] = []
    
    public init(frame: Frame, lines: [[Int]], lineWidth: CGFloat, lineColor: CGColor) {
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = true
        
        let frameImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.image = UIImage(cgImage: frame.image)
            imageView.frame = CGRect(x: 0, y: 0, width: frame.image.width, height: frame.image.height)
            imageView.backgroundColor = UIColor(red: 70/255, green: 70/255, blue: 70/255, alpha: 1.0)
            imageView.clipsToBounds = true
            return imageView
        }()
        addSubview(frameImageView)
        
        for line in lines {
            
            let shapeLayer = CAShapeLayer()
            let path = UIBezierPath()
            
            
            let t = Double(line[0]) * Double.pi / 180.0
            let r = Double(line[1])
            
            path.move(to: CGPoint(x: 0.0, y: CGFloat(r / cos(t))))
            path.addLine(to: CGPoint(x: CGFloat(frame.image.width), y: CGFloat((r - Double(frame.image.width) * sin(t)) / cos(t))))
            
            shapeLayer.path = path.cgPath
            
            shapeLayer.strokeColor = lineColor
            shapeLayer.lineWidth = lineWidth
            
            frameImageView.layer.addSublayer(shapeLayer)
        }
        
        frameImageView.transform = CGAffineTransform(scaleX: 560 / frameImageView.frame.width, y: 560 / frameImageView.frame.width)
        frameImageView.center = CGPoint(x: 280, y: 235)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
