import Foundation
import AVFoundation
import UIKit

// MARK: Function for applying a hough transform to a binary edge detected image
public func applyHoughTransform(toFrame frame: Frame, neighborhoodSize: Int, threshold: Int) -> [[Int]] {
    
    let diagonalLength = Int(Double(exactly: frame.image.width)! * sqrt(2.0))
    
//    Buffer for hough space accumulator. Indexed by theta (x) and rho (y)
    guard let accumulatorData = CFDataCreateMutable(nil, diagonalLength * 180) else { fatalError("Couldn't allocate memory for accumulator") }
    guard let accumulatorPointer = CFDataGetMutableBytePtr(accumulatorData) else { fatalError("Couldn't get pointer for accumulator") }
    
//    Fill buffer with 0s
    var zero = UInt8(0)
    for _ in 0 ..< diagonalLength * 180 {
        CFDataAppendBytes(accumulatorData, &zero, 1)
    }
    
//    Iterate over each pixel in image
    for x in 1 ..< frame.image.width {
        for y in 1 ..< frame.image.height {
            let pixelValue = getPixel(data: frame.pointer, x: x, y: y, imageWidth: frame.image.width)
            
            guard pixelValue == 255 else { continue }
            
//            Draw sinusoidal curve in accumulator. Evaluate at each value of theta
            for t in 0 ..< 180 {
                // TODO: Fix this, way too many variable initializations
                let xDouble = Double(exactly: x)!
                let yDouble = Double(exactly: y)!
                
                let tDouble = Double(exactly: t)! * Double.pi / 180
                
                let pDouble = xDouble * sin(tDouble) + yDouble * cos(tDouble)
                let p = Int(pDouble)
                
                guard p > 0 else { continue }
                
                let currentValue = getPixel(data: accumulatorPointer, x: t, y: p, imageWidth: 180)
                guard currentValue < 255 else { continue }
                setPixel(value: currentValue + 1, data: accumulatorPointer, x: t, y: p, imageWidth: 180)
            }
        }
    }
    
    //    Initalize buffer for filtered peaks
    //    TODO: rethink this? Can probably get by without making a new buffer
    guard let peakData = CFDataCreateMutableCopy(nil, CFDataGetLength(accumulatorData), accumulatorData) else { fatalError("Couldn't allocate data for peaks") }
    guard let peakPointer = CFDataGetMutableBytePtr(peakData) else { fatalError("Couldn't get pointer for peaks") }
    
    let neighborhoodSizeDouble = Double(exactly: neighborhoodSize)!
    let deviation = Int(ceil(neighborhoodSizeDouble / 2.0))
    
//    Iterate over image, skipping sides
    for t in deviation ..< (180 - deviation) {
        for p in deviation ..< (diagonalLength - deviation) {
            let pixelValue = getPixel(data: accumulatorPointer, x: t, y: p, imageWidth: 180)
            
            
            guard pixelValue > threshold else {
                setPixel(value: 0, data: peakPointer, x: t, y: p, imageWidth: 180)
                continue
            }
            
            let surroundingPixelValues = getSurroundingPixelValues(data: accumulatorPointer, size: neighborhoodSize, x: t, y: p, imageWidth: 180)
            
            for value in surroundingPixelValues {
                if value > pixelValue {
                    setPixel(value: 0, data: peakPointer, x: t, y: p, imageWidth: 180)
                    break
                }
            }
        }
    }
    
    var lines: [[Int]] = []
    
    for t in 1 ..< 180 {
        for p in 1 ..< diagonalLength {
            if getPixel(data: peakPointer, x: t, y: p, imageWidth: 180) > threshold {
                lines.append([t, p])
            }
        }
    }
    
    return lines
}

let performHoughTransform = { (params: [AlgorithmParameter], previousResult: Any, _: Frame) -> (UIView, Any) in
    guard let previousFrame = previousResult as? Frame else { fatalError("performHoughTransform takes a Frame for previousResult, recieved other") }
    
    guard let neighborhoodSize = params.first(where: { $0.name == "Neighborhood Size" } ) else { fatalError("performHoughTransform takes a Neighborhood Size parameter") }
    
    guard let threshold = params.first(where: { $0.name == "Threshold" } ) else { fatalError("performHoughTransform takes a Threshold parameter") }
    
    let houghLines = applyHoughTransform(toFrame: previousFrame, neighborhoodSize: neighborhoodSize.value, threshold: threshold.value)
    
    
    return (LineVisualization(frame: previousFrame, lines: houghLines, lineWidth: 1.0, lineColor: UIColor(red: 0/255, green: 122/255, blue: 255/255, alpha: 1.0).cgColor), houghLines)
}
