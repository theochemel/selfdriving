import Foundation
import UIKit

public class NavigationBar: UIView {
    
    weak var delegate: NavigationBarDelegate?
    
    var currentStep: Int = 0
    
    var pipeline: [PipelineElement]
    
    var previousStepNameLabel: UILabel!
    
    var nextStepNameLabel: UILabel!
    
    var currentStepNameLabel: UILabel!
    
    var previousButtonContainerView: UIView!
    
    var nextButtonContainerView: UIView!
    
    var isNavigationEnabled = true
    
    public init(forPipeline pipeline: [PipelineElement]) {
        
        self.pipeline = pipeline
        
        super.init(frame: .zero)
        
        translatesAutoresizingMaskIntoConstraints = false
        
        backgroundColor = UIColor(red: 54/255, green: 54/255, blue: 54/255, alpha: 1.0)
                
        previousButtonContainerView = {
            let view = UIView()
            view.backgroundColor = .clear
            view.translatesAutoresizingMaskIntoConstraints = false
            view.alpha = currentStep > 0 ? 1.0 : 0.4
            
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.didPressPrevious))
            view.addGestureRecognizer(tapGestureRecognizer)
            
            return view
        }()
        addSubview(previousButtonContainerView)
        
        NSLayoutConstraint.activate([
            previousButtonContainerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16.0),
            previousButtonContainerView.topAnchor.constraint(equalTo: topAnchor, constant: 1.0),
            previousButtonContainerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -1.0),
            previousButtonContainerView.widthAnchor.constraint(equalToConstant: 140.0),
        ])
        
        let previousButtonChevron: UIImageView = {
            let imageView = UIImageView(image: UIImage(named: "back-chevron.png"))
            imageView.contentMode = .scaleToFill
            imageView.translatesAutoresizingMaskIntoConstraints = false
            return imageView
        }()
        previousButtonContainerView.addSubview(previousButtonChevron)
        
        NSLayoutConstraint.activate([
            previousButtonChevron.topAnchor.constraint(equalTo: previousButtonContainerView.topAnchor, constant: 5.0),
            previousButtonChevron.bottomAnchor.constraint(equalTo: previousButtonContainerView.bottomAnchor, constant: -7.0),
            previousButtonChevron.widthAnchor.constraint(equalToConstant: 8.0),
            previousButtonChevron.leadingAnchor.constraint(equalTo: previousButtonContainerView.leadingAnchor),
        ])
        
        let previousButtonLabel: UILabel = {
            let label = UILabel()
            label.text = "Previous"
            label.textColor = .white
            label.font = UIFont.systemFont(ofSize: 10.0)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        previousButtonContainerView.addSubview(previousButtonLabel)
        
        NSLayoutConstraint.activate([
            previousButtonLabel.leadingAnchor.constraint(equalTo: previousButtonChevron.trailingAnchor, constant: 8.0),
            previousButtonLabel.trailingAnchor.constraint(equalTo: previousButtonContainerView.trailingAnchor),
            previousButtonLabel.bottomAnchor.constraint(equalTo: previousButtonContainerView.centerYAnchor),
            previousButtonLabel.heightAnchor.constraint(equalToConstant: 12.0),
        ])
        
        previousStepNameLabel = {
            let label = UILabel()
            label.text = currentStep > 0 ? pipeline[currentStep - 1].name : "------"
            label.textColor = UIColor.lightGray
            label.textAlignment = .left
            label.font = UIFont.systemFont(ofSize: 8.0)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        previousButtonContainerView.addSubview(previousStepNameLabel)
        
        NSLayoutConstraint.activate([
            previousStepNameLabel.leadingAnchor.constraint(equalTo: previousButtonChevron.trailingAnchor, constant: 8.0),
            previousStepNameLabel.trailingAnchor.constraint(equalTo: previousButtonContainerView.trailingAnchor),
            previousStepNameLabel.topAnchor.constraint(equalTo: previousButtonContainerView.centerYAnchor),
            previousStepNameLabel.heightAnchor.constraint(equalToConstant: 10.0),
        ])
        
        nextButtonContainerView = {
            let view = UIView()
            view.backgroundColor = .clear
            view.translatesAutoresizingMaskIntoConstraints = false
            
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.didPressNext))
            view.addGestureRecognizer(tapGestureRecognizer)
            
            return view
        }()
        addSubview(nextButtonContainerView)
        
        NSLayoutConstraint.activate([
            nextButtonContainerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16.0),
            nextButtonContainerView.topAnchor.constraint(equalTo: topAnchor, constant: 1.0),
            nextButtonContainerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -1.0),
            nextButtonContainerView.widthAnchor.constraint(equalToConstant: 140.0),
        ])
        
        let nextButtonChevron: UIImageView = {
            let imageView = UIImageView(image: UIImage(named: "next-chevron.png"))
            imageView.contentMode = .scaleToFill
            imageView.translatesAutoresizingMaskIntoConstraints = false
            return imageView
        }()
        nextButtonContainerView.addSubview(nextButtonChevron)
        
        NSLayoutConstraint.activate([
            nextButtonChevron.topAnchor.constraint(equalTo: nextButtonContainerView.topAnchor, constant: 5.0),
            nextButtonChevron.bottomAnchor.constraint(equalTo: nextButtonContainerView.bottomAnchor, constant: -7.0),
            nextButtonChevron.widthAnchor.constraint(equalToConstant: 8.0),
            nextButtonChevron.trailingAnchor.constraint(equalTo: nextButtonContainerView.trailingAnchor),
        ])
        
        let nextButtonLabel: UILabel = {
            let label = UILabel()
            label.text = "Next"
            label.textColor = .white
            label.textAlignment = .right
            label.font = UIFont.systemFont(ofSize: 10.0)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        nextButtonContainerView.addSubview(nextButtonLabel)
        
        NSLayoutConstraint.activate([
            nextButtonLabel.leadingAnchor.constraint(equalTo: nextButtonContainerView.leadingAnchor),
            nextButtonLabel.trailingAnchor.constraint(equalTo: nextButtonChevron.leadingAnchor, constant: -8.0),
            nextButtonLabel.bottomAnchor.constraint(equalTo: nextButtonContainerView.centerYAnchor),
            nextButtonLabel.heightAnchor.constraint(equalToConstant: 12.0),
        ])
        
        nextStepNameLabel = {
            let label = UILabel()
            label.text = currentStep < (pipeline.count - 1) ? pipeline[currentStep + 1].name : "------"
            label.textColor = UIColor.lightGray
            label.textAlignment = .right
            label.font = UIFont.systemFont(ofSize: 8.0)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        
        nextButtonContainerView.addSubview(nextStepNameLabel)
        
        NSLayoutConstraint.activate([
            nextStepNameLabel.leadingAnchor.constraint(equalTo: nextButtonContainerView.leadingAnchor),
            nextStepNameLabel.trailingAnchor.constraint(equalTo: nextButtonChevron.leadingAnchor, constant: -8.0),
            nextStepNameLabel.topAnchor.constraint(equalTo: nextButtonContainerView.centerYAnchor),
            nextStepNameLabel.heightAnchor.constraint(equalToConstant: 10.0),
        ])
        
        currentStepNameLabel = {
            let label = UILabel()
            label.text = pipeline[currentStep].name
            label.textColor = .white
            label.font = UIFont.systemFont(ofSize: 13.0, weight: .regular)
            label.textAlignment = .center
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        addSubview(currentStepNameLabel)
        
        NSLayoutConstraint.activate([
            currentStepNameLabel.leadingAnchor.constraint(equalTo: previousButtonContainerView.trailingAnchor, constant: 16.0),
            currentStepNameLabel.trailingAnchor.constraint(equalTo: nextButtonContainerView.leadingAnchor, constant: -16.0),
            currentStepNameLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            currentStepNameLabel.heightAnchor.constraint(equalToConstant: 20.0),
        ])
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update() {
        currentStepNameLabel.text = pipeline[currentStep].name
        previousStepNameLabel.text = currentStep > 0 ? pipeline[currentStep - 1].name : "------"
        previousButtonContainerView.alpha = currentStep > 0 ? 1.0 : 0.4
        nextStepNameLabel.text = currentStep < (pipeline.count - 1) ? pipeline[currentStep + 1].name : "------"
        nextButtonContainerView.alpha = currentStep < (pipeline.count - 1) ? 1.0 : 0.4
    }
    
    @objc func didPressPrevious() {
        guard isNavigationEnabled else { return }
        if currentStep > 0 {
            currentStep -= 1
            delegate?.navigationBarDidPressPrevious()
            update()
        }
    }
    
    @objc func didPressNext() {
        guard isNavigationEnabled else { return }
        if currentStep < (pipeline.count - 1) {
            currentStep += 1
            delegate?.navigationBarDidPressNext()
            update()
        }
    }
    
    func enableNavigation() {
        isNavigationEnabled = true
    }
    
    func disableNavigation() {
        isNavigationEnabled = false
    }
}

protocol NavigationBarDelegate: class {
    func navigationBarDidPressPrevious()
    func navigationBarDidPressNext()
}
