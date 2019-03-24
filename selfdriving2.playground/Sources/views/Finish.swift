import Foundation
import UIKit

class FinishView: UIView {
        
    init(resultView: UIView) {
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        backgroundColor = UIColor(red: 46/255, green: 46/255, blue: 46/255, alpha: 1.0)
        
        let thatsItLabel: UILabel = {
            let label = UILabel()
            label.text = "That's it - nice work!"
            label.textColor = UIColor.white
            label.font = UIFont.systemFont(ofSize: 70.0, weight: .thin)
            label.textAlignment = .center
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        addSubview(thatsItLabel)
        
        NSLayoutConstraint.activate([
            thatsItLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            thatsItLabel.heightAnchor.constraint(equalToConstant: 92.0),
            thatsItLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16.0),
            thatsItLabel.widthAnchor.constraint(equalToConstant: 600.0),
        ])
        
        let resultContainerView: UIView = {
            let view = UIView()
            view.backgroundColor = .clear
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        addSubview(resultContainerView)

        NSLayoutConstraint.activate([
            resultContainerView.widthAnchor.constraint(equalToConstant: 560),
            resultContainerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            resultContainerView.topAnchor.constraint(equalTo: thatsItLabel.bottomAnchor, constant: 12.0),
            resultContainerView.heightAnchor.constraint(equalToConstant: resultView.frame.height)
        ])
        layoutSubviews()
        
        resultView.frame.origin.y = -68
        resultView.subviews.first?.layer.cornerRadius = 28.0
        
        resultContainerView.addSubview(resultView)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
