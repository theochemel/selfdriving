import UIKit
import PlaygroundSupport
import AVFoundation
import Foundation

// MARK: Start of actual program execution
guard let videoFilePath = Bundle.main.url(forResource: "solidWhiteRight", withExtension: ".mp4") else { fatalError("Couldn't find test footage.")}

let video = Video(videoAt: videoFilePath)

// TODO: rewrite this in own words
class ActionTarget {

    let closure: () -> ()

    init(closure: @escaping () -> ()) {
        self.closure = closure
    }

    @objc func action() {
        closure()
    }
}

struct PipelineElement {
    var name: String!
    var shortName: String!
    var description: String!
    var function: (Any) -> Any
}

let pipeline: [PipelineElement] = [

    PipelineElement(name: "Get next frame", shortName: "Frame", description: "Retrieving the next frame from the video", function: { (frameIndex) -> Any in
        return video.getFrame(frameIndex as! Int)
    }),

    PipelineElement(name: "Convert to grayscale", shortName: "Grayscale", description: "Converting the frame to grayscale for further processing.", function: { (frame) -> Any in
        return convertToGrayscale(frame as! Frame)
    }),

    PipelineElement(name: "Apply Gaussian blur", shortName: "Blur", description: "Applying a Gaussian blur helps to reduce the impact of noise in the image", function: { (frame) -> Any in
        return applyKernel(kernel: [2, 4, 5, 4, 2, 4, 9, 12, 9, 4, 5, 12, 15, 12, 5, 4, 9, 12, 9, 4, 2, 4, 5, 4, 2], kernelWidth: 5, divideBy: 159, toFrame: frame as! Frame)
    }),

    PipelineElement(name: "Apply Canny edge detection", shortName: "Edges", description: "Applying Canny edge detection to highlight the edges in the image.", function: { (frame) -> Any in
        return applyCanny(toFrame: frame as! Frame, lowThreshold: 200, highThreshold: 240)
    }),

    PipelineElement(name: "Apply Hough transform", shortName: "Lines", description: "Applying a Hough transform to the edge-detected image, to find the mathmatical representation of edge lines.", function: { (frame) -> Any in
        return applyHoughTransform(toFrame: frame as! Frame, neighborhoodSize: 11, threshold: 60)
    })

    ]


var liveView: UIView = {
    let view = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 576, height: 450))
    view.clipsToBounds = false
    view.backgroundColor = .white
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
}()

PlaygroundPage.current.needsIndefiniteExecution = true
PlaygroundPage.current.liveView = liveView

var imageView: UIImageView = {
    let view = UIImageView(frame: CGRect(x: 0, y: 0, width: 576, height: 324))
    view.contentMode = .scaleAspectFit
    view.layer.masksToBounds = true
    return view
}()

liveView.addSubview(imageView)

var shadowView: UIView = {
   let view = UIView(frame: CGRect(x: 0.0, y: imageView.frame.height, width: liveView.frame.width, height: liveView.frame.height - imageView.frame.height))

    view.backgroundColor = .white

    view.layer.shadowColor = UIColor.black.cgColor
    view.layer.shadowOpacity = 0.6
    view.layer.shadowOffset = CGSize(width: 0.0, height: -4.0)
    view.layer.shadowRadius = 16

    view.layer.masksToBounds = false
    return view
}()

liveView.addSubview(shadowView)

var pipelineView: UIView = {
    let view = UIView(frame: CGRect(x: 10.0, y: imageView.frame.maxY + 10.0, width: liveView.frame.width - 20.0, height: (liveView.frame.height - imageView.frame.height) - 44))
    view.backgroundColor = .red
    return view
}()

var pipelineLine: CAShapeLayer = {
    let path = UIBezierPath()
    path.move(to: CGPoint(x: 40.0, y: pipelineView.bounds.height / 2))
    path.addLine(to: CGPoint(x: pipelineView.bounds.width - 40, y: pipelineView.bounds.height / 2))

    let layer = CAShapeLayer()
    layer.path = path.cgPath
    layer.strokeColor = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1.0).cgColor
    layer.lineWidth = 2.0

    return layer
}()

pipelineView.layer.addSublayer(pipelineLine)

let spacing = (pipelineView.bounds.width - 80) / CGFloat(pipeline.count - 1)

for x in 0 ... (pipeline.count - 1) {
    var pipelineDot: CAShapeLayer = {
        let path = UIBezierPath(ovalIn: CGRect(x: spacing * CGFloat(x) + 38, y: pipelineView.bounds.midY - 4, width: 8, height: 8))

        let layer = CAShapeLayer()
        layer.path = path.cgPath
        layer.fillColor = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1.0).cgColor

        return layer
    }()

    pipelineView.layer.addSublayer(pipelineDot)

    var stepLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: spacing * CGFloat(x) + 37, y: pipelineView.bounds.midY + 20, width: 50, height: 12))
        label.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 3.5)
        label.font = label.font.withSize(10)
        label.text = pipeline[x].shortName
        return label
    }()
    pipelineView.addSubview(stepLabel)
}

var currentStepIndicator: UIView = {
    let view = UIView(frame: CGRect(x: 37, y: 30, width: 10, height: 15))
    view.backgroundColor = .clear
    return view
}()

var currentStepIndicatorLayer: CAShapeLayer = {
    let path = UIBezierPath()
    path.move(to: CGPoint(x: 0, y: 0))
    path.addLine(to: CGPoint(x: 0, y: 10))
    path.addLine(to: CGPoint(x: 5, y: 15))
    path.addLine(to: CGPoint(x: 10, y: 10))
    path.addLine(to: CGPoint(x: 10, y: 0))
    path.addLine(to: CGPoint(x: 0, y: 0))

    let layer = CAShapeLayer()
    layer.path = path.cgPath
    layer.fillColor = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1.0).cgColor
    return layer
}()

var currentStepLabel: UILabel = {
    let label = UILabel(frame: CGRect(x: -7, y: 6, width: 100, height: 20))
    label.text = "Get Next Frame"
    label.textAlignment = .center
    label.font = label.font.withSize(10.0)
    return label
}()

currentStepIndicator.layer.addSublayer(currentStepIndicatorLayer)
pipelineView.addSubview(currentStepIndicator)
pipelineView.addSubview(currentStepLabel)

liveView.addSubview(pipelineView)

var currentFrame = video.getFrame(0)

var currentStep = pipeline[0]

var pipelineIndex = 0

var frameIndex = 0

let detailsButtonTarget = ActionTarget {
    print("Details button pressed")
}

let nextButtonTarget = ActionTarget {
    print("Next button pressed")

    if pipelineIndex < pipeline.count - 1 {
        pipelineIndex += 1
        currentStep = pipeline[pipelineIndex]

    } else {
        currentStep = pipeline[0]
        pipelineIndex = 0
        frameIndex += 1
    }

    if currentStep.name == "Get next frame" {
        currentFrame = currentStep.function(frameIndex) as! Frame
        imageView.image = UIImage(cgImage: currentFrame.image)
    } else if currentStep.name == "Apply Hough transform" {
        var lines = currentStep.function(currentFrame)
        print(lines)
    } else {
        currentFrame = currentStep.function(currentFrame) as! Frame
        imageView.image = UIImage(cgImage: currentFrame.image)
    }

}

var buttonsView: UIView = {
    let view = UIView(frame: CGRect(x: liveView.frame.width / 2 - 64, y: liveView.frame.height - 24, width: 128, height: 15))
    return view
}()

liveView.addSubview(buttonsView)

var detailsButton: UIButton = {
    let button = UIButton(frame: CGRect(x: 0, y: 0.0, width: 60, height: 15))
    button.setTitle("Details", for: .normal)
    button.titleLabel?.font = button.titleLabel?.font.withSize(10.0)
    button.backgroundColor = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1.0)
    button.setTitleColor(.white, for: .normal)
    button.layer.cornerRadius = 5.0
    button.addTarget(detailsButtonTarget, action: #selector(ActionTarget.action), for: .touchUpInside)
    return button
}()

buttonsView.addSubview(detailsButton)

var nextButton: UIButton = {
    let button = UIButton(frame: CGRect(x: buttonsView.bounds.width / 2 + 4, y: 0.0, width: 60, height: 15))
    button.setTitle("Next", for: .normal)
    button.titleLabel?.font = button.titleLabel?.font.withSize(10.0)
    button.backgroundColor = UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1.0)
    button.setTitleColor(.white, for: .normal)
    button.layer.cornerRadius = 5.0
    button.addTarget(nextButtonTarget, action: #selector(ActionTarget.action), for: .touchUpInside)
    return button
}()

buttonsView.addSubview(nextButton)

var frame = video.getFrame(0)
imageView.image = UIImage(cgImage: frame.image)
