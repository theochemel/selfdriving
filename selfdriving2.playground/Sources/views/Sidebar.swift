import Foundation
import UIKit

public class Sidebar: UIView {
        
    public init(withAlgorithmParameters algorithmParameters: [AlgorithmParameter], name: String, description: String, shortDescription: String, parameterDelegate: AlgorithmParameterControlDelegate) {
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
        
        let nameLabel: UILabel = {
            let label = UILabel()
            label.textColor = .white
            label.font = UIFont.systemFont(ofSize: 16.0)
            label.text = name
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        stackView.addArrangedSubview(nameLabel)
        
//        NSLayoutConstraint.activate([
//            nameLabel.heightAnchor.constraint(equalToConstant: 20.0),
//        ])
        
        let shortDescriptionLabel: UILabel = {
            let label = UILabel()
            label.text = shortDescription
            label.textColor = UIColor.lightGray
            label.font = UIFont.systemFont(ofSize: 8.0)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        stackView.addArrangedSubview(shortDescriptionLabel)
        
//        NSLayoutConstraint.activate([
//            shortDescriptionLabel.heightAnchor.constraint(equalToConstant: 10.0),
//        ])
        
        let postShortDescriptionDividerLine: UIView = {
            let view = UIView()
            view.backgroundColor = UIColor.lightGray
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        stackView.addArrangedSubview(postShortDescriptionDividerLine)
        
        NSLayoutConstraint.activate([
            postShortDescriptionDividerLine.heightAnchor.constraint(equalToConstant: 0.5),
        ])
        
        
        if algorithmParameters.count > 0 {
        
            for algorithmParameter in algorithmParameters {
                let algorithmParameterControl = AlgorithmParameterControl(forAlgorithmParameter: algorithmParameter)
                algorithmParameterControl.delegate = parameterDelegate
                algorithmParameterControl.setContentHuggingPriority(.required, for: .vertical)
                stackView.addArrangedSubview(algorithmParameterControl)
                
                NSLayoutConstraint.activate([
                    algorithmParameterControl.heightAnchor.constraint(equalToConstant: 34.0),
                ])
            }
            
            let postParamsDividerLine: UIView = {
                let view = UIView()
                view.backgroundColor = UIColor.lightGray
                view.translatesAutoresizingMaskIntoConstraints = false
                return view
            }()
            stackView.addArrangedSubview(postParamsDividerLine)
            
            NSLayoutConstraint.activate([
                postParamsDividerLine.heightAnchor.constraint(equalToConstant: 0.5),
            ])
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
}
