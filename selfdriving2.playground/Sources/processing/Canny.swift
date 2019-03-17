import Foundation
import AVFoundation
import UIKit

public func applyCanny(toFrame frame: Frame, lowThreshold: UInt8, highThreshold: UInt8) -> Frame {
    // MARK: Apply sobel operators in the x and y direction
    let xFrame = applyKernel(kernel: [-1, 0, 1, -2, 0, 2, -1, 0, 1], kernelWidth: 3, divideBy: 1, toFrame: frame)
    let yFrame = applyKernel(kernel: [-1, -2, -1, 0, 0, 0, 1, 2, 1], kernelWidth: 3, divideBy: 1, toFrame: frame)
    
    let numberOfPixels = frame.image.width * frame.image.height
    
    // MARK: Compute gradient magnitude and direction for each pixel
    guard let gradientData = CFDataCreateMutable(nil, numberOfPixels) else { fatalError("Couldn't allocate data for gradient") }
    guard let gradient = CFDataGetMutableBytePtr(gradientData) else { fatalError("Couldn't create pointer for gradient") }
    guard let directionData = CFDataCreateMutable(nil, numberOfPixels) else { fatalError("Couldn't allocate data for direction") }
    guard let direction = CFDataGetMutableBytePtr(directionData) else { fatalError("Couldn't create pointer for gradient") }
    
    for x in 0 ..< numberOfPixels {
        let sobelXValue = xFrame.pointer[x]
        let sobelYValue = yFrame.pointer[x]
        
        let hypotValue = hypotf(Float(exactly: sobelXValue)!, Float(exactly: sobelYValue)!)
        
        var hypot: UInt8!
        
        if hypotValue < 0 {
            hypot = 0
        } else if hypotValue < 255 {
            hypot = UInt8(hypotValue)
        } else {
            hypot = 255
        }
        
        CFDataAppendBytes(gradientData, &hypot, 1)
        
        var directionValue = atan2(Double(exactly: sobelXValue)!, Double(exactly: sobelYValue)!) * 180
        
        var direction: UInt8!
        
        if directionValue < 0 {
            directionValue += 180
        }
        
        if (0 ... 22.5).contains(directionValue) || (157.5 ... 180).contains(directionValue) {
            direction = 0
        } else if (22.5 ... 67.5).contains(directionValue) {
            direction = 45
        } else if (67.5 ... 112.5).contains(directionValue) {
            direction = 90
        } else {
            direction = 135
        }
        
        CFDataAppendBytes(directionData, &direction, 1)
    }
    
    // MARK: Perform non-maximum suppression
    guard let nonMaximumSuppressionData = CFDataCreateMutableCopy(nil, CFDataGetLength(gradientData), gradientData) else { fatalError("Couldn't allocate data for non-maximum suppression") }
    guard let nonMaximumSuppression = CFDataGetMutableBytePtr(nonMaximumSuppressionData) else { fatalError("Couldn't create pointer for non-maximum suppression") }
    
    for x in 1 ... (frame.image.width - 1) {
        for y in 1 ... (frame.image.height - 1) {
            let pixelValue = getPixel(data: gradient, x: x, y: y, imageWidth: frame.image.width)
            let pixelDirection = getPixel(data: direction, x: x, y: y, imageWidth: frame.image.width)
            
            var firstNeighborValue: UInt8!
            var secondNeighborValue: UInt8!
            
            if pixelDirection == 0 {
                firstNeighborValue = getPixel(data: gradient, x: x + 1, y: y, imageWidth: frame.image.width)
                secondNeighborValue = getPixel(data: gradient, x: x - 1, y: y, imageWidth: frame.image.width)
            } else if pixelDirection == 45 {
                firstNeighborValue = getPixel(data: gradient, x: x + 1, y: y + 1, imageWidth: frame.image.width)
                secondNeighborValue = getPixel(data: gradient, x: x - 1, y: y - 1, imageWidth: frame.image.width)
            } else if pixelDirection == 90 {
                firstNeighborValue = getPixel(data: gradient, x: x, y: y + 1, imageWidth: frame.image.width)
                secondNeighborValue = getPixel(data: gradient, x: x, y: y - 1, imageWidth: frame.image.width)
            } else {
                firstNeighborValue = getPixel(data: gradient, x: x - 1, y: y + 1, imageWidth: frame.image.width)
                secondNeighborValue = getPixel(data: gradient, x: x + 1, y: y - 1, imageWidth: frame.image.width)
            }
            
            if pixelValue < firstNeighborValue && pixelValue < secondNeighborValue {
                setPixel(value: 0, data: nonMaximumSuppression, x: x, y: y, imageWidth: frame.image.width)
            }
        }
    }
    
    // MARK: Perform double threshold
    guard let highThresholdData = CFDataCreateMutableCopy(nil, CFDataGetLength(nonMaximumSuppressionData), nonMaximumSuppressionData) else { fatalError("Couldn't allocate data for double threshold") }
    guard let highThresholdPointer = CFDataGetMutableBytePtr(highThresholdData) else { fatalError("Couldn't create pointer for double threshold")}
    guard let lowThresholdData = CFDataCreateMutableCopy(nil, CFDataGetLength(nonMaximumSuppressionData), nonMaximumSuppressionData) else { fatalError("Couldn't allocate data for double threshold") }
    guard let lowThresholdPointer = CFDataGetMutableBytePtr(lowThresholdData) else { fatalError("Couldn't create pointer for double threshold") }
    
    for x in 0 ... numberOfPixels {
        let pixelValue = nonMaximumSuppression[x]
        
        if pixelValue < lowThreshold {
            lowThresholdPointer[x] = 0
            highThresholdPointer[x] = 0
        } else if pixelValue < highThreshold {
            lowThresholdPointer[x] = pixelValue
            highThresholdPointer[x] = 0
        } else {
            lowThresholdPointer[x] = 0
            highThresholdPointer[x] = 255
        }
    }
    
    // MARK: Perform hysteresis
    
    for x in 1 ... (frame.image.width - 1) {
        for y in 1 ... (frame.image.height - 1) {
            if getPixel(data: lowThresholdPointer, x: x, y: y, imageWidth: frame.image.width) != 0 {
                let surroundingPixelValues = getSurroundingPixelValues(data: highThresholdPointer, size: 3, x: x, y: y, imageWidth: frame.image.width)
                if surroundingPixelValues.contains(255) {
                    setPixel(value: 255, data: highThresholdPointer, x: x, y: y, imageWidth: frame.image.width)
                }
            }
            
        }
    }
    
    return Frame(fromGrayscaleData: highThresholdData, bytesPerRow: frame.image.bytesPerRow)
}

public let performCannyEdgeDetection = { (params: [AlgorithmParameter], previousResult: Any) -> (UIView, Any) in
    
    guard let previousFrame = previousResult as? Frame else { fatalError("performCannyEdgeDetection takes a Frame for previousResult, recieved other") }
    print(params)
    
    guard let lowThreshold = params.first(where: { $0.name == "Low Threshold" }) else { fatalError("performCannyEdgeDetection takes a Low Threshold parameter") }
    guard let highThreshold = params.first(where: { $0.name == "High Threshold" }) else { fatalError("performCannyEdgeDetection takes a High Threshold parameter") }
    
    let cannyFrame = applyCanny(toFrame: previousFrame, lowThreshold: UInt8(lowThreshold.value), highThreshold: UInt8(highThreshold.value))
    let cannyImageView = UIImageView(image: UIImage(cgImage: cannyFrame.image))
    
    return (cannyImageView, cannyFrame)
}
