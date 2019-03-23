import Foundation
import UIKit

let performGaussianBlur = { (params: [AlgorithmParameter], previousResult: Any, _: Frame) -> (UIView, Any) in
    guard let previousFrame = previousResult as? Frame else { fatalError("performGaussianBlur takes a Frame for previousResult, recieved other") }
    
    guard let blurRadius = params.first(where: { $0.name == "Blur Radius" }) else { fatalError("performGaussianBlur takes a Blur Radius parameter") }
    
    let frame = Frame(fromImage: previousFrame.image)
    
    var radius = blurRadius.value
    
    if radius % 2 == 0 {
        radius += 1
    }
    
    let kernel = Array(repeating: 1, count: radius * radius)
    
    let blurFrame = applyKernel(kernel: kernel, kernelWidth: radius, divideBy: radius * radius, toFrame: frame)
    
    let blurImageView = UIImageView(image: UIImage(cgImage: blurFrame.image))
    blurImageView.contentMode = .scaleAspectFit
    blurImageView.backgroundColor = UIColor(red: 70/255, green: 70/255, blue: 70/255, alpha: 1.0)
    
    return (blurImageView, blurFrame)
}
