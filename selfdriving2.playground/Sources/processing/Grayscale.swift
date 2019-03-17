import Foundation
import UIKit

// MARK: Function for converting a frame to a single-channel grayscale image.
// Not properly converting to grayscale! Just taking the first (red?) value of each pixel. Works ok.
public func convertToGrayscale(_ frame: Frame) -> Frame {
    
    guard let newImageData = CFDataCreateMutable(nil, CFDataGetLength(frame.data)) else { fatalError("Couldn't create new image data") }
    
    for x in stride(from: 1, through: CFDataGetLength(frame.data), by: 4) {
        CFDataAppendBytes(newImageData, &frame.pointer[x], 1)
    }
    
    let newFrame = Frame(fromGrayscaleData: newImageData, bytesPerRow: frame.image.width)
    
    return newFrame
}

public var performGrayscaleConversion = { (params: [AlgorithmParameter], previousResult: Any) -> (UIView, Any) in
    print("Performing grayscale conversion")
    
    guard let previousFrame = previousResult as? Frame else { fatalError("performGrayscaleConversion takes a Frame for previousResult, recieved other") }
    
    let grayscaleFrame = convertToGrayscale(previousFrame)
    let grayscaleImageView = UIImageView(image: UIImage(cgImage: grayscaleFrame.image))
    
    return (grayscaleImageView, grayscaleFrame)
}
