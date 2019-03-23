import Foundation
import UIKit

public class AppViewController: UIViewController, NavigationBarDelegate, AlgorithmParameterControlDelegate {
    
    var currentStep = 0
    
    var resultContainerView: UIView!
    
    var loadingView: UIView!
    
    var isExecuting = false
    
    var originalFrame: Frame = video.getFrame(0)
    
    let pipeline: [PipelineElement] = [
        PipelineElement(name: "Get Frame",
                        description: "...",
                        shortDescription: "Lorem ipsum dolor sit amet",
                        shouldDisplayLoadingAnimation: false,
                        algorithmParameters: [
                            AlgorithmParameter(name: "Frame Index", description: "...", min: 0, max: 200),
                        ],
                        execute: performGetFrame),
        PipelineElement(name: "Grayscale Conversion",
                        description: "...",
                        shortDescription: "Converts a color image to grayscale for faster processing",
                        shouldDisplayLoadingAnimation: false,
                        algorithmParameters: [],
                        execute: performGrayscaleConversion),
        PipelineElement(name: "Gaussian Blur",
                        description: "...",
                        shortDescription: "...",
                        shouldDisplayLoadingAnimation: true,
                        algorithmParameters: [
                            AlgorithmParameter(name: "Blur Radius", description: "...", min: 1, max: 5),
                        ],
                        execute: performGaussianBlur),
        PipelineElement(name: "Canny Edge Detection",
                        description: "Canny edge detection is a multistep process for detecting edges in an image. It takes a grayscale image as input, and returns a binary image. Pixels are either white, constituting an edge, or black. To learn more about how Canny edge detection is implemented, be sure to check out 'Canny.swift' in the 'processing' source folder, and click the button below.",
                        shortDescription: "A multi-step process for finding the edges in an image",
                        shouldDisplayLoadingAnimation: true,
                        algorithmParameters: [
                            AlgorithmParameter(name: "Low Threshold", description: "...", min: 0, max: 255),
                            AlgorithmParameter(name: "High Threshold", description: "...", min: 0, max: 255),
                        ],
                        execute: performCannyEdgeDetection),
        PipelineElement(name: "Hough Transform",
                        description: "...",
                        shortDescription: "...",
                        shouldDisplayLoadingAnimation: false,
                        algorithmParameters: [
                            AlgorithmParameter(name: "Neighborhood Size", description: "...", min: 1, max: 30),
                            AlgorithmParameter(name: "Threshold", description: "...", min: 20, max: 255),
                        ],
                        execute: performHoughTransform),
        PipelineElement(name: "Line Grouping",
                        description: "...",
                        shortDescription: "...",
                        shouldDisplayLoadingAnimation: false,
                        algorithmParameters: [
                            AlgorithmParameter(name: "Left Min Slope", description: "...", min: 0, max: 90),
                            AlgorithmParameter(name: "Left Max Slope", description: "...", min: 0, max: 90),
                            AlgorithmParameter(name: "Right Min Slope", description: "...", min: 91, max: 180),
                            AlgorithmParameter(name: "Right Max Slope", description: "...", min: 91, max: 180),
                        ],
                        execute: performLineGrouping),
    ]
    
    var navigationBar: NavigationBar!
    
    var sidebar: Sidebar!
    
    public override func viewDidLoad() {
        view.frame = CGRect(x: 0.0, y: 0.0, width: 760, height: 500)
        view.translatesAutoresizingMaskIntoConstraints = true
        view.backgroundColor = UIColor(red: 70/255, green: 70/255, blue: 70/255, alpha: 1.0)
        
        navigationBar = NavigationBar(forPipeline: pipeline)
        navigationBar.delegate = self
        
        view.addSubview(navigationBar)
        
        NSLayoutConstraint.activate([
            navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navigationBar.topAnchor.constraint(equalTo: view.topAnchor),
            navigationBar.heightAnchor.constraint(equalToConstant: 30.0),
        ])
        
        let dividerLineView: UIView = {
            let view = UIView()
            view.backgroundColor = .black
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        view.addSubview(dividerLineView)
        
        NSLayoutConstraint.activate([
            dividerLineView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dividerLineView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dividerLineView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            dividerLineView.heightAnchor.constraint(equalToConstant: 1.0),
        ])
        
        resultContainerView = {
            let view = UIView()
            view.backgroundColor = .clear
            view.translatesAutoresizingMaskIntoConstraints = false
            view.clipsToBounds = true
            return view
        }()
        view.addSubview(resultContainerView)
        
        NSLayoutConstraint.activate([
            resultContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            resultContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -200.0),
            resultContainerView.topAnchor.constraint(equalTo: dividerLineView.bottomAnchor),
            resultContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        loadingView = {
            let view = UIView()
            view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
            view.alpha = 0.0
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        
        let loadingSpinner: UIActivityIndicatorView = {
            let spinner = UIActivityIndicatorView()
            spinner.tintColor = .white
            spinner.startAnimating()
            spinner.translatesAutoresizingMaskIntoConstraints = false
            return spinner
        }()
        
        loadingView.addSubview(loadingSpinner)
        
        NSLayoutConstraint.activate([
            loadingSpinner.widthAnchor.constraint(equalToConstant: 40.0),
            loadingSpinner.heightAnchor.constraint(equalToConstant: 40.0),
            loadingSpinner.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor),
            loadingSpinner.centerYAnchor.constraint(equalTo: loadingView.centerYAnchor),
        ])
        
        
        view.addSubview(loadingView)
        
        NSLayoutConstraint.activate([
            loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -200.0),
            loadingView.topAnchor.constraint(equalTo: dividerLineView.bottomAnchor),
            loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        

        view.layoutSubviews()
        
        updateSidebar()
        
        executeCurrentStep()
    }
    
    func updateSidebar() {        
        sidebar?.removeFromSuperview()
        
        sidebar = Sidebar(withAlgorithmParameters: pipeline[currentStep].algorithmParameters, description: pipeline[currentStep].description, delegate: self)
        
        view.addSubview(sidebar)
        
        NSLayoutConstraint.activate([
            sidebar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            sidebar.topAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: 1.0),
            sidebar.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            sidebar.widthAnchor.constraint(equalToConstant: 200.0),
        ])
    }
    
    func executeCurrentStep() {
//        Animation Start
        print("Executing")
        isExecuting = true
        
        let input = (currentStep > 0) ? pipeline[currentStep - 1].result : 0
        
        if pipeline[currentStep].shouldDisplayLoadingAnimation {
            UIView.animate(withDuration: 0.2, delay: 0.1, options: [], animations: {
                self.loadingView.alpha = 1.0
            }, completion: nil)
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            let (resultView, result) = self.pipeline[self.currentStep].execute(self.pipeline[self.currentStep].algorithmParameters, input!, self.originalFrame)
            self.pipeline[self.currentStep].resultView = resultView
            self.pipeline[self.currentStep].result = result
            
            if self.pipeline[self.currentStep].name == "Get Frame" {
                self.originalFrame = result as! Frame
            }
            
            DispatchQueue.main.async {
                if self.currentStep > 0 {
                    self.pipeline[self.currentStep - 1].resultView.removeFromSuperview()
                }
                
                self.resultContainerView.addSubview(self.pipeline[self.currentStep].resultView)
                self.pipeline[self.currentStep].resultView.frame = self.resultContainerView.bounds
                                
                UIView.animate(withDuration: 0.2) {
                    self.loadingView.alpha = 0.0
                }
                
                self.isExecuting = false
            }
        }
    }
    
    func navigationBarDidPressNext() {
        guard isExecuting == false else { return }
        currentStep += 1
        updateSidebar()
        executeCurrentStep()
    }
    
    func navigationBarDidPressPrevious() {
        guard isExecuting == false else { return }
        pipeline[currentStep].resultView.removeFromSuperview()
        currentStep -= 1
        updateSidebar()
        resultContainerView.addSubview(pipeline[currentStep].resultView)
        pipeline[currentStep].resultView.frame = resultContainerView.bounds
    }
    
    public func algorithmParameterControlDidChangeValue(algorithmParameter: AlgorithmParameter) {
        //        TODO: handle this more gracefully?
        guard isExecuting == false else { return }
        
        print("Parameter \(algorithmParameter.name) changed to value \(algorithmParameter.value)")
        if let updatedParamIndex = pipeline[currentStep].algorithmParameters.index(where: { $0.name == algorithmParameter.name }) {
            pipeline[currentStep].algorithmParameters[updatedParamIndex].value = algorithmParameter.value
            executeCurrentStep()
        }
    }
}
