import Foundation
import AVFoundation

public class Frame {
    public var image: CGImage!
    public var data: CFMutableData!
    public var pointer: UnsafeMutablePointer<UInt8>!
    
    public init(fromImage: CGImage) {
        image = fromImage
        guard let originalData = image.dataProvider?.data else { fatalError("Couldn't get data to initialize frame") }
        guard let newData = CFDataCreateMutableCopy(nil, 0, originalData) else { fatalError("Couldn't create a mutable copy to initialize frame") }
        guard let newPointer = CFDataGetMutableBytePtr(newData) else { fatalError("Couldn't create pointer to initialize frame") }
        data = newData
        pointer = newPointer
    }
    
    public init(fromGrayscaleData: CFMutableData, bytesPerRow: Int) {
        data = fromGrayscaleData
        guard let newPointer = CFDataGetMutableBytePtr(data) else { fatalError("Couldn't create pointer to initalize frame") }
        pointer = newPointer
        
        guard let dataProvider = CGDataProvider(data: data) else { fatalError("Couldn't create data provider") }
        let numberOfPixels = CFDataGetLength(data)
        let height = Int(numberOfPixels / bytesPerRow)
        guard let updatedImage = CGImage(width: bytesPerRow, height: height, bitsPerComponent: 8, bitsPerPixel: 8, bytesPerRow: bytesPerRow, space: CGColorSpaceCreateDeviceGray(), bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.none.rawValue), provider: dataProvider, decode: nil, shouldInterpolate: false, intent: CGColorRenderingIntent.defaultIntent) else { fatalError("Couldn't create updated image") }
        image = updatedImage
    }
}


