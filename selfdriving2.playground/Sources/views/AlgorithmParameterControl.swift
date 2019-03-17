import Foundation
import UIKit

public class AlgorithmParameterControl: UIView {
    weak var delegate: AlgorithmParameterControlDelegate?
    
    var algorithmParameter: AlgorithmParameter!
    
    public init(forAlgorithmParameter algorithmParameter: AlgorithmParameter) {
        self.algorithmParameter = algorithmParameter
        
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
                
        let nameLabel: UILabel = {
            let label = UILabel()
            label.textColor = .white
            label.text = algorithmParameter.name
            label.font = UIFont.systemFont(ofSize: 10.0)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        addSubview(nameLabel)
                
        NSLayoutConstraint.activate([
            nameLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            nameLabel.topAnchor.constraint(equalTo: topAnchor),
            nameLabel.heightAnchor.constraint(equalToConstant: 12.0)
        ])
        
        let valueSlider: UISlider = {
            let slider = UISlider()
            slider.setThumbImage(UIImage(named: "slider-thumb.png"), for: .normal)
            slider.setThumbImage(UIImage(named: "slider-thumb.png"), for: .selected)
            slider.isContinuous = false
            slider.minimumValue = Float(algorithmParameter.min)
            slider.maximumValue = Float(algorithmParameter.max)
            slider.value = Float(algorithmParameter.value)
            slider.addTarget(self, action: #selector(sliderValueDidChange(_:)), for: .valueChanged)
            slider.translatesAutoresizingMaskIntoConstraints = false
            return slider
        }()
        addSubview(valueSlider)
        
        NSLayoutConstraint.activate([
            valueSlider.leadingAnchor.constraint(equalTo: leadingAnchor),
            valueSlider.trailingAnchor.constraint(equalTo: trailingAnchor),
            valueSlider.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8.0),
            valueSlider.heightAnchor.constraint(equalToConstant: 8.0),
        ])
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func sliderValueDidChange(_ sender: UISlider) {
        algorithmParameter.value = Int(sender.value)
        delegate?.algorithmParameterControlDidChangeValue(algorithmParameter: algorithmParameter)
    }
}

public protocol AlgorithmParameterControlDelegate: class {
    func algorithmParameterControlDidChangeValue(algorithmParameter: AlgorithmParameter)
}
