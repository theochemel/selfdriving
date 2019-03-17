import Foundation
import UIKit

public class AppViewController: UIViewController, NavigationBarDelegate, AlgorithmParameterControlDelegate {
    
    var currentStep = 0
    
    var resultContainerView: UIView!
    
    let pipeline: [PipelineElement] = [
        PipelineElement(name: "Get Frame",
                        description: "...",
                        shortDescription: "Lorem ipsum dolor sit amet",
                        algorithmParameters: [
                            AlgorithmParameter(name: "Frame Index", description: "...", min: 0, max: 200),
                        ],
                        execute: performGetFrame),
        PipelineElement(name: "Grayscale Conversion",
                        description: "...",
                        shortDescription: "Converts a color image to grayscale for faster processing",
                        algorithmParameters: [],
                        execute: performGrayscaleConversion),
        PipelineElement(name: "Canny Edge Detection",
                        description: "Canny edge detection is a multistep process for detecting edges in an image. It takes a grayscale image as input, and returns a binary image. Pixels are either white, constituting an edge, or black. To learn more about how Canny edge detection is implemented, be sure to check out 'Canny.swift' in the 'processing' source folder, and click the button below.",
                        shortDescription: "A multi-step process for finding the edges in an image",
                        algorithmParameters: [
                            AlgorithmParameter(name: "Low Threshold", description: "...", min: 0, max: 255),
                            AlgorithmParameter(name: "High Threshold", description: "...", min: 0, max: 255),
                        ],
                        execute: performCannyEdgeDetection),
        PipelineElement(name: "Hough Transform",
                        description: "...",
                        shortDescription: "...",
                        algorithmParameters: [
                            AlgorithmParameter(name: "Neighborhood Size", description: "...", min: 1, max: 30),
                            AlgorithmParameter(name: "Threshold", description: "...", min: 0, max: 255),
                        ],
                        execute: performHoughTransform),
    ]
    
    var navigationBar: NavigationBar!
    
    var sidebar: Sidebar!
    
    public override func viewDidLoad() {
        view.frame = CGRect(x: 0.0, y: 0.0, width: 760, height: 500)
        view.translatesAutoresizingMaskIntoConstraints = true
        
        navigationBar = NavigationBar(forPipeline: pipeline)
        navigationBar.delegate = self
        
        view.addSubview(navigationBar)
        
        NSLayoutConstraint.activate([
            navigationBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            navigationBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            navigationBar.topAnchor.constraint(equalTo: view.topAnchor),
            navigationBar.heightAnchor.constraint(equalToConstant: 30.0),
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
            resultContainerView.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            resultContainerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
        
        updateSidebar()
        
        executeCurrentStep()
    }
    
    func updateSidebar() {        
        sidebar?.removeFromSuperview()
        
        sidebar = Sidebar(withAlgorithmParameters: pipeline[currentStep].algorithmParameters, description: pipeline[currentStep].description, delegate: self)
        
        view.addSubview(sidebar)
        
        NSLayoutConstraint.activate([
            sidebar.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            sidebar.topAnchor.constraint(equalTo: navigationBar.bottomAnchor),
            sidebar.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            sidebar.widthAnchor.constraint(equalToConstant: 200.0),
        ])
    }
    
    func executeCurrentStep() {
//        Animation Start
        print("Executing")
        let input = (currentStep > 0) ? pipeline[currentStep - 1].result : 0
        
        let (resultView, result) = pipeline[currentStep].execute(pipeline[currentStep].algorithmParameters, input)
        pipeline[currentStep].resultView = resultView
        pipeline[currentStep].result = result
        
//        Animation End
        
        if currentStep > 0 {
            pipeline[currentStep - 1].resultView.removeFromSuperview()
        }
    
        resultContainerView.addSubview(pipeline[currentStep].resultView)
    }
    
    func navigationBarDidPressNext() {
        currentStep += 1
        updateSidebar()
        executeCurrentStep()
    }
    
    func navigationBarDidPressPrevious() {
        pipeline[currentStep].resultView.removeFromSuperview()
        currentStep -= 1
        updateSidebar()
        resultContainerView.addSubview(pipeline[currentStep].resultView)
    }
    
    public func algorithmParameterControlDidChangeValue(algorithmParameter: AlgorithmParameter) {
        print("Parameter \(algorithmParameter.name) changed to value \(algorithmParameter.value)")
        if let updatedParamIndex = pipeline[currentStep].algorithmParameters.index(where: { $0.name == algorithmParameter.name }) {
            pipeline[currentStep].algorithmParameters[updatedParamIndex].value = algorithmParameter.value
            executeCurrentStep()
        }
    }
}
