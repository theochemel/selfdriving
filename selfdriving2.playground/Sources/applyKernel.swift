import Foundation
import AVFoundation

public func applyKernel(kernel: [Int], kernelWidth: Int, divideBy: Int, toFrame frame: Frame) -> Frame {
    guard let processedData = CFDataCreateMutableCopy(nil, CFDataGetLength(frame.data), frame.data) else { fatalError("Couldn't allocate data for processed image") }
    guard let processed = CFDataGetMutableBytePtr(processedData) else { fatalError("Couldn't make a pointer for processed image data") }
    
    for x in 2 ... (frame.image.width - 2) {
        for y in 2 ... (frame.image.height - 2) {
            let surroundingPixelValues = getSurroundingPixelValues(data: frame.pointer, size: kernelWidth, x: x, y: y, imageWidth: frame.image.width)
            
            let multipliedValues = surroundingPixelValues.enumerated().map { (offset: Int, element: UInt8) -> Int in
                return Int(element) * kernel[offset]
            }
            
            let summedValues = multipliedValues.reduce(0, {$0 + $1})
            
            let pixelValue = (summedValues / divideBy)
            
            var finalPixelValue: UInt8!
            if pixelValue < -255 {
                finalPixelValue = 255
            } else if pixelValue < 0 {
                finalPixelValue = UInt8(abs(pixelValue))
            } else if pixelValue < 255 {
                finalPixelValue = UInt8(pixelValue)
            } else {
                finalPixelValue = 255
            }
            
            setPixel(value: finalPixelValue, data: processed, x: x, y: y, imageWidth: frame.image.width)
            
        }
    }
    
    return Frame(fromGrayscaleData: processedData, bytesPerRow: frame.image.bytesPerRow)
}
