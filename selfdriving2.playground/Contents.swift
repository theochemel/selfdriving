import UIKit
import PlaygroundSupport
import AVFoundation
import Foundation

var liveView: UIView = {
    let view = UIView(frame: CGRect(x: 0.0, y: 0.0, width: 760, height: 500))
    view.clipsToBounds = false
    view.backgroundColor = .white
    view.translatesAutoresizingMaskIntoConstraints = true
    return view
}()

PlaygroundPage.current.needsIndefiniteExecution = true
PlaygroundPage.current.liveView = liveView

let appViewController = AppViewController()
liveView.addSubview(appViewController.view)
