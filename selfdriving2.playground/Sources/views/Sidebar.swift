import Foundation
import UIKit

public class Sidebar: UIView {
    
    public init(withAlgorithmParameters algorithmParameters: [AlgorithmParameter], description: String, delegate: AlgorithmParameterControlDelegate) {
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        backgroundColor = UIColor(red: 46/255, green: 46/255, blue: 46/255, alpha: 1.0)
        
        let stackView: UIStackView = {
            let stackView = UIStackView()
            stackView.axis = .vertical
            stackView.alignment = .fill
            stackView.distribution = .fill
            stackView.spacing = 8.0
            stackView.translatesAutoresizingMaskIntoConstraints = false
            return stackView
        }()
        addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.0),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.0),
            stackView.topAnchor.constraint(equalTo: topAnchor, constant: 8.0),
        ])
        
        let learnMoreButton: UIButton = {
            let button = UIButton()
            button.setTitle("Learn More", for: .normal)
            button.setTitleColor(UIColor.white, for: .normal)
            button.backgroundColor = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1.0)
            button.layer.cornerRadius = 5
            button.addTarget(self, action: #selector(didPressLearnMoreButton), for: .touchUpInside)
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }()
        
        addSubview(learnMoreButton)
        
        NSLayoutConstraint.activate([
            learnMoreButton.widthAnchor.constraint(equalToConstant: 184.0),
            learnMoreButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            learnMoreButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8.0),
            learnMoreButton.heightAnchor.constraint(equalToConstant: 28.0),
        ])
        
        if algorithmParameters.count > 0 {
            let parametersLabel: UILabel = {
                let label = UILabel()
                label.textColor = .white
                label.font = UIFont.systemFont(ofSize: 16.0)
                label.text = "Parameters:"
                label.translatesAutoresizingMaskIntoConstraints = false
                return label
            }()
            
            stackView.addArrangedSubview(parametersLabel)
            
            NSLayoutConstraint.activate([
                parametersLabel.heightAnchor.constraint(equalToConstant: 20.0)
            ])
        
            for algorithmParameter in algorithmParameters {
                let algorithmParameterControl = AlgorithmParameterControl(forAlgorithmParameter: algorithmParameter)
                algorithmParameterControl.delegate = delegate
                algorithmParameterControl.setContentHuggingPriority(.required, for: .vertical)
                stackView.addArrangedSubview(algorithmParameterControl)
                
                NSLayoutConstraint.activate([
                    algorithmParameterControl.heightAnchor.constraint(equalToConstant: 34.0),
                ])
            }
        }
        
        let descriptionLabel: UILabel = {
            let label = UILabel()
            label.text = description
            label.textColor = .white
            label.font = UIFont.systemFont(ofSize: 10.0)
            label.numberOfLines = 0
            label.lineBreakMode = .byWordWrapping
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        stackView.addArrangedSubview(descriptionLabel)
        

    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didPressLearnMoreButton() {
        print("Learn more button pressed")
    }
}
