import Foundation


// MARK: Helper functions for getting and setting pixels from a grayscale image
public func getPixel(data: UnsafeMutablePointer<UInt8>, x: Int, y: Int, imageWidth: Int) -> UInt8 {
    let index = y * imageWidth + x
    return data[index]
}

public func setPixel(value: UInt8, data: UnsafeMutablePointer<UInt8>, x: Int, y: Int, imageWidth: Int) {
    let index = y * imageWidth + x
    data[index] = value
}


public func getSurroundingPixelValues(data: UnsafeMutablePointer<UInt8>, size: Int, x: Int, y: Int, imageWidth: Int) -> [UInt8] {
    let deviation = Int(size / 2)
    
    var surroundingPixelValues: [UInt8] = []
    
    for x in (x - deviation) ... (x + deviation) {
        for y  in (y - deviation) ... (y + deviation) {
            surroundingPixelValues.append(getPixel(data: data, x: x, y: y, imageWidth: imageWidth))
        }
    }
    
    return surroundingPixelValues
}
