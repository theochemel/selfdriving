import Foundation
import AVFoundation
import UIKit

// MARK: Video class

public class Video {
    public let filePath: URL!
    public let videoAsset: AVAsset!
    public let imageGenerator: AVAssetImageGenerator!
    
    public let frameRate: Float!
    public let frameCount: Int!
    
    public init(videoAt path: URL) {
        filePath = path
        videoAsset = AVAsset(url: filePath)
        imageGenerator = AVAssetImageGenerator(asset: videoAsset)
        
        imageGenerator.requestedTimeToleranceBefore = CMTime.zero
        imageGenerator.requestedTimeToleranceAfter = CMTime.zero
        
        guard let assetTrack = videoAsset.tracks(withMediaType: AVMediaType.video).first else { fatalError("Couldn't create a video asset track") }
        frameRate = assetTrack.nominalFrameRate
        
        frameCount = Int((videoAsset.duration.seconds * Double(frameRate)))
    }
    
    public func getFrame(_ index: Int) -> Frame {        
        var image: CGImage!
        do {
            image = try imageGenerator.copyCGImage(at: CMTime(seconds: Double(index) / 25, preferredTimescale: CMTimeScale(25)), actualTime: nil)
        } catch {
            fatalError("Couldn't generate image")
        }
        
        return Frame(fromImage: image)
    }
}

let videoFilePath = Bundle.main.url(forResource: "solidWhiteRight", withExtension: ".mp4")

let video = Video(videoAt: videoFilePath!)

public let performGetFrame = { (params: [AlgorithmParameter], previousResult: Any, _: Frame) -> (UIView, Any) in
    guard let frameIndex = params.first(where: { $0.name == "Frame Index" }) else { fatalError("performGetFrame takes a Frame Index parameter") }
    
    print("Getting frame")
    
    let frame = video.getFrame(frameIndex.value)
    
    let frameImageView = UIImageView(image: UIImage(cgImage: frame.image))
    frameImageView.contentMode = .scaleAspectFit
    frameImageView.backgroundColor = UIColor(red: 70/255, green: 70/255, blue: 70/255, alpha: 1.0)
    
    return (frameImageView, frame)
}
