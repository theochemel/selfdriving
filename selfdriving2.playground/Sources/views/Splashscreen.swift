import Foundation
import UIKit

public class SplashscreenViewController: UIViewController {
    
    let tooltipPoints: [TooltipPoint] = [
        TooltipPoint(point: CGPoint(x: 164, y: 70), text: "Navigate between steps using the bar at the top."),
        TooltipPoint(point: CGPoint(x: 584, y: 91), text: "Tune each algorithm using the sliders on the right."),
        TooltipPoint(point: CGPoint(x: 164, y: 171), text: "The result of each step will display on the left."),
        TooltipPoint(point: CGPoint(x: 584, y: 151), text: "A description of each algorithm is on the right"),
        TooltipPoint(point: CGPoint(x: 584, y: 241), text: "Click here to open a web page with more info."),
    ]
    
    var continueButtonTrailingConstraint: NSLayoutConstraint!
    var descriptionLabelCenterXConstraint: NSLayoutConstraint!
    var authorLabelCenterXConstraint: NSLayoutConstraint!
    var mockupContainerViewCenterXConstraint: NSLayoutConstraint!
    
    var isDisplayingMockup = false
    
    public override func viewDidLoad() {
        view.frame = CGRect(x: 0.0, y: 0.0, width: 760, height: 500)
        view.backgroundColor = UIColor(red: 46/255, green: 46/255, blue: 46/255, alpha: 1.0)
        
        view.translatesAutoresizingMaskIntoConstraints = true
        
        let selfdrivingLabel: UILabel = {
            let label = UILabel()
            label.text = "selfdriving"
            label.textColor = UIColor.white
            label.font = UIFont.systemFont(ofSize: 84.0, weight: .thin)
            label.textAlignment = .center
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        view.addSubview(selfdrivingLabel)
        
        NSLayoutConstraint.activate([
            selfdrivingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            selfdrivingLabel.heightAnchor.constraint(equalToConstant: 92.0),
            selfdrivingLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 48.0),
            selfdrivingLabel.widthAnchor.constraint(equalToConstant: 400.0),
        ])
        
        let descriptionLabel: UILabel = {
            let label = UILabel()
            label.text = "An interactive computer vision pipeline for detecting lane lines in a self driving car."
            label.textColor = UIColor(red: 182/255, green: 182/255, blue: 182/255, alpha: 1.0)
            label.font = UIFont.systemFont(ofSize: 30.0, weight: .light)
            label.textAlignment = .center
            label.lineBreakMode = .byWordWrapping
            label.numberOfLines = 2
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        view.addSubview(descriptionLabel)
        
        descriptionLabelCenterXConstraint = descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        
        NSLayoutConstraint.activate([
            descriptionLabel.heightAnchor.constraint(equalToConstant: 72.0),
            descriptionLabel.widthAnchor.constraint(equalToConstant: 600.0),
            descriptionLabel.topAnchor.constraint(equalTo: selfdrivingLabel.bottomAnchor, constant: 16.0),
            descriptionLabelCenterXConstraint,
        ])
        
        let authorLabel: UILabel = {
            let label = UILabel()
            label.text = "Made with ❤️ by Theo Chemel for WWDC 19"
            label.textColor = UIColor(red: 182/255, green: 182/255, blue: 182/255, alpha: 1.0)
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 14.0, weight: .light)
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        view.addSubview(authorLabel)
        
        authorLabelCenterXConstraint = authorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        
        NSLayoutConstraint.activate([
            authorLabel.heightAnchor.constraint(equalToConstant: 18.0),
            authorLabel.widthAnchor.constraint(equalToConstant: 600.0),
            authorLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 24.0),
            authorLabelCenterXConstraint,
        ])
        
        let continueButton: UIButton = {
            let button = UIButton()
            button.setTitle("Continue", for: .normal)
            button.setTitleColor(UIColor.white, for: .normal)
            button.backgroundColor = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1.0)
            button.layer.cornerRadius = 5
            button.addTarget(self, action: #selector(didPressContinueButton(_:)), for: .touchUpInside)
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }()
        view.addSubview(continueButton)
        
        continueButtonTrailingConstraint = continueButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16.0)
        
        NSLayoutConstraint.activate([
            continueButton.widthAnchor.constraint(equalToConstant: 184.0),
            continueButton.heightAnchor.constraint(equalToConstant: 32.0),
            continueButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16.0),
            continueButtonTrailingConstraint,
        ])
        
        let mockupContainerView: UIView = {
            let view = UIView()
            view.backgroundColor = .clear
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        view.addSubview(mockupContainerView)
        
        mockupContainerViewCenterXConstraint = mockupContainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 760)
        
        NSLayoutConstraint.activate([
            mockupContainerView.widthAnchor.constraint(equalToConstant: 760.0),
            mockupContainerView.topAnchor.constraint(equalTo: selfdrivingLabel.bottomAnchor, constant: -18.0),
            mockupContainerView.bottomAnchor.constraint(equalTo: continueButton.topAnchor),
            mockupContainerViewCenterXConstraint,
        ])
        
        let mockupImageView: UIImageView = {
            let imageView = UIImageView()
            imageView.image = UIImage(named: "mockup.png")
            imageView.contentMode = .scaleAspectFit
            imageView.translatesAutoresizingMaskIntoConstraints = false
            return imageView
        }()
        mockupContainerView.addSubview(mockupImageView)
        
        NSLayoutConstraint.activate([
            mockupImageView.widthAnchor.constraint(equalToConstant: 380.0),
            mockupImageView.heightAnchor.constraint(equalToConstant: 200.0),
            mockupImageView.centerXAnchor.constraint(equalTo: mockupContainerView.centerXAnchor),
            mockupImageView.centerYAnchor.constraint(equalTo: mockupContainerView.centerYAnchor),
        ])
        
        for tooltipPoint in tooltipPoints {
            mockupContainerView.addSubview(tooltipPoint)
        }

    }
    
    @objc func didPressContinueButton(_ sender: UIButton) {
        
        if isDisplayingMockup == false {
            UIView.transition(with: sender, duration: 0.2, options: [.transitionCrossDissolve], animations: {
                sender.setTitle("Get Started", for: .normal)
            }, completion: nil)
            
            UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseInOut], animations: {
                self.continueButtonTrailingConstraint.constant = -288.0
                self.view.layoutIfNeeded()
            }, completion: nil)
            UIView.animate(withDuration: 0.2, delay: 0.02, options: [.curveEaseInOut], animations: {
                self.descriptionLabelCenterXConstraint.constant = -680.0
                self.view.layoutIfNeeded()
            }, completion: nil)
            UIView.animate(withDuration: 0.2, delay: 0.04, options: [.curveEaseInOut], animations: {
                self.authorLabelCenterXConstraint.constant = -680.0
                self.view.layoutIfNeeded()
            }, completion: nil)
            UIView.animate(withDuration: 0.2, delay: 0.1, options: [.curveEaseInOut], animations: {
                self.mockupContainerViewCenterXConstraint.constant = 0
                self.view.layoutIfNeeded()
            }, completion: { _ in
                for tooltipPoint in self.tooltipPoints {
                    tooltipPoint.startPulseAnimation()
                }
            })
            
            isDisplayingMockup = true
        } else {
            UIView.animate(withDuration: 0.2, animations: {
                self.view.alpha = 0.0
                self.view.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
            }) { (_) in
                self.view.removeFromSuperview()
            }
        }
    }
    
    public override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard isDisplayingMockup else { return }
                
        for tooltipPoint in tooltipPoints {
            tooltipPoint.hideDescriptionLabel()
        }
    }
}
