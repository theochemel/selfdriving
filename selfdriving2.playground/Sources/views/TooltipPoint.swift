import Foundation
import UIKit

class TooltipPoint: UIView {
    
    var descriptionContainer: UIView!
    
    var isDisplayingDescriptionLabel = false
    
    var outerCircleView: UIView!
    
    init(point: CGPoint, text: String) {
        super.init(frame: CGRect(origin: point, size: CGSize(width: 14, height: 14)))
        
        backgroundColor = .clear

        outerCircleView = UIView()
        outerCircleView.backgroundColor = .clear
        outerCircleView.frame = CGRect(x: 0, y: 0, width: 14, height: 14)
        let outerCircleLayer = CAShapeLayer()
        let outerCircle = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: 14, height: 14))
        outerCircleLayer.path = outerCircle.cgPath
        outerCircleLayer.lineWidth = 1.0
        outerCircleLayer.strokeColor = UIColor.white.cgColor
        outerCircleLayer.fillColor = UIColor.clear.cgColor

        outerCircleView.layer.addSublayer(outerCircleLayer)
        
        addSubview(outerCircleView)
        
        let button: UIButton = {
            let button = UIButton()
            button.frame = CGRect(x: 2, y: 2, width: 10.0, height: 10.0)
            button.backgroundColor = UIColor.white
            button.layer.cornerRadius = 5.0
            button.addTarget(self, action: #selector(didTap), for: .touchUpInside)
            return button
        }()
        
        addSubview(button)
        
        descriptionContainer = {
            let view = UIView()
            view.frame = CGRect(x: point.x < 380 ? -150: 24, y: 0, width: 140, height: 38)
            view.backgroundColor = UIColor(red: 46/255, green: 46/255, blue: 46/255, alpha: 1.0)
            view.layer.cornerRadius = 10
            view.layer.borderColor = UIColor(red: 182/255, green: 182/255, blue: 182/255, alpha: 1.0).cgColor
            view.layer.borderWidth = 1
            view.alpha = 0.0
            return view
        }()
        addSubview(descriptionContainer)
        
        let descriptionLabel: UILabel = {
            let label = UILabel()
            label.frame = descriptionContainer.bounds.insetBy(dx: 2, dy: 0)
            label.text = text
            label.textAlignment = .center
            label.numberOfLines = 2
            label.font = UIFont.systemFont(ofSize: 10.0, weight: .regular)
            label.textColor = UIColor(red: 182/255, green: 182/255, blue: 182/255, alpha: 1.0)
            return label
        }()
        descriptionContainer.addSubview(descriptionLabel)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didTap() {
        
        if !isDisplayingDescriptionLabel {
            UIView.animate(withDuration: 0.2) {
                self.descriptionContainer.alpha = 1.0
            }
            isDisplayingDescriptionLabel = true
        } else {
            self.hideDescriptionLabel()
        }
    }
    
    func hideDescriptionLabel() {
        UIView.animate(withDuration: 0.2) {
            self.descriptionContainer.alpha = 0.0
        }
        isDisplayingDescriptionLabel = false
    }
    
    func startPulseAnimation() {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: [.repeat, .autoreverse, .curveEaseInOut], animations: {
            self.outerCircleView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        }, completion: nil)
    }
    
}
