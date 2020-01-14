import UIKit

var str = "Hello, playground"

class ActionView: UIView {
    
    let antennas = [
        [CAShapeLayer(), CAShapeLayer()],
        [CAShapeLayer(), CAShapeLayer()],
        [CAShapeLayer(), CAShapeLayer()],
        [CAShapeLayer(), CAShapeLayer()]
    ]
    
    let antennaLines = [
        [CAShapeLayer(), CAShapeLayer()],
        [CAShapeLayer(), CAShapeLayer()],
        [CAShapeLayer(), CAShapeLayer()],
        [CAShapeLayer(), CAShapeLayer()]
    ]
    
    let thetaOne = UILabel()
    let thetaTwo = UILabel()
    let thetaThree = UILabel()
    let thetaFour = UILabel()
    
    private let signalColor = UIColor.lightGray.cgColor
    private var pulseArray = [CAShapeLayer]()
    
    let node = CAShapeLayer()
    var nodeOrigin = CGPoint.zero{
        didSet{
            node.frame.origin = nodeOrigin
            
            self.layoutSubviews()
        }
    }
    

    convenience init() {
        self.init(frame: CGRect.zero)
        self.initView()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.initView()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initView()
    }
    
    internal func initView() {
        self.backgroundColor = UIColor.white
        antennas.forEach{
            $0.forEach{ antenna in
                self.layer.addSublayer(antenna)
            }
        }
        
        antennaLines.forEach{
            $0.forEach{ antennaLine in
                self.layer.addSublayer(antennaLine)
            }
        }
        [thetaOne, thetaTwo, thetaThree, thetaFour].enumerated().forEach{
            $0.element.text = "Theta = 56"
            self.addSubview($0.element)
        }
        
        self.layer.addSublayer(node)
        let nodeShape =
            UIBezierPath(
                roundedRect: CGRect(
                    origin: CGPoint.zero,
                    size: CGSize(width: 10, height: 10)),
                cornerRadius: 10)
        
        nodeOrigin = CGPoint(x: self.frame.midX, y: self.frame.midY)
        
        node.fillColor = UIColor.green.cgColor
        node.path = nodeShape.cgPath
        createPulse()
        
    }
    
    func createPulse(){
        
        for _ in 0...8 {
            let circularPath = UIBezierPath(arcCenter: .zero, radius: UIScreen.main.bounds.size.width/2.0, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
            let pulseLayer = CAShapeLayer()
            pulseLayer.path = circularPath.cgPath
            pulseLayer.lineWidth = 2.0
            pulseLayer.fillColor = UIColor.clear.cgColor
            pulseLayer.lineCap = CAShapeLayerLineCap.round
            pulseLayer.position = nodeOrigin
            self.layer.addSublayer(pulseLayer)
            pulseArray.append(pulseLayer)
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
            self.animatePulsatingLayerAt(index: 0)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                self.animatePulsatingLayerAt(index: 1)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                    self.animatePulsatingLayerAt(index: 2)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                        self.animatePulsatingLayerAt(index: 3)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                            self.animatePulsatingLayerAt(index: 4)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                                self.animatePulsatingLayerAt(index: 5)
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                                    self.animatePulsatingLayerAt(index: 6)
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2, execute: {
                                        self.animatePulsatingLayerAt(index: 7)
                                    })
                                })
                            })
                        })
                    })
                })
            })
        })
    }
    
    func animatePulsatingLayerAt(index:Int) {
        
        //Giving color to the layer
        pulseArray[index].strokeColor = signalColor
        
        //Creating scale animation for the layer, from and to value should be in range of 0.0 to 1.0
        // 0.0 = minimum
        //1.0 = maximum
        let scaleAnimation = CABasicAnimation(keyPath: "transform.scale")
        scaleAnimation.fromValue = 0.0
        scaleAnimation.toValue = 2
        
        //Creating opacity animation for the layer, from and to value should be in range of 0.0 to 1.0
        // 0.0 = minimum
        //1.0 = maximum
        let opacityAnimation = CABasicAnimation(keyPath: #keyPath(CALayer.opacity))
        opacityAnimation.fromValue = 1.0
        opacityAnimation.toValue = 0.5
        
        // Grouping both animations and giving animation duration, animation repat count
        let groupAnimation = CAAnimationGroup()
        groupAnimation.animations = [scaleAnimation, opacityAnimation]
        groupAnimation.duration = 3
        groupAnimation.repeatCount = .greatestFiniteMagnitude
        groupAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        //adding groupanimation to the layer
        pulseArray[index].add(groupAnimation, forKey: "groupanimation")
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        antennas.enumerated().forEach{
            $0.element.forEach{ antennaShape in
                let circlePath =
                    UIBezierPath(
                        roundedRect: CGRect(
                            origin: CGPoint.zero,
                            size: CGSize(width: 10, height: 10)),
                        cornerRadius: 10)
                
                antennaShape.fillColor = UIColor.black.cgColor
                antennaShape.path = circlePath.cgPath
                
            }
            
            switch $0.offset {
            case 0:
                let offset = 0
                $0.element.enumerated().forEach{ antenna in
                    let i = antenna.offset
                    antenna.element.frame.origin =
                        CGPoint(
                            x: self.frame.midX + (i == 0 ? 50 : -50),
                            y: -5)
                    
                    let line = UIBezierPath()
                    let origin = antenna.element.frame.origin
                    line.move(to: CGPoint(x: origin.x + 5, y: origin.y + 5))
                    line.addLine(to: CGPoint(x: nodeOrigin.x + 5, y: nodeOrigin.y + 5))
                    antennaLines[offset][i].strokeColor = UIColor.clear.cgColor
                    antennaLines[offset][i].path = line.cgPath
                }
                
                thetaOne.sizeToFit()
                
                var h: CGFloat = 0
                var a: CGFloat = 0
                if CGPointDistance(from: nodeOrigin, to: $0.element[0].frame.origin) > CGPointDistance(from: nodeOrigin, to: $0.element[1].frame.origin){
                    antennaLines[offset][0].strokeColor = UIColor.green.cgColor
                    h = CGPointDistance(from: nodeOrigin, to: $0.element[0].frame.origin)
                    a = sqrt(pow(nodeOrigin.x - $0.element[0].frame.origin.x, 2))
                    thetaOne.frame.origin = CGPoint(x: $0.element[0].frame.origin.x + 10, y: $0.element[0].frame.origin.y + 10)
                }
                else{
                    h = CGPointDistance(from: nodeOrigin, to: $0.element[1].frame.origin)
                    a = sqrt(pow(nodeOrigin.x - $0.element[1].frame.origin.x, 2))
                    antennaLines[offset][1].strokeColor = UIColor.green.cgColor
                    thetaOne.frame.origin = CGPoint(x: $0.element[1].frame.origin.x - thetaOne.frame.width - 10, y: $0.element[1].frame.origin.y + 10)
                }
                
                
                let theta = round((acos(a/h)*180/CGFloat.pi)*100)/100
                thetaOne.text = "Theta = \(theta)"
                
            case 1:
                let offset = 1
                $0.element.enumerated().forEach{ antenna in
                    let i = antenna.offset
                    antenna.element.frame.origin =
                        CGPoint(
                            x: self.frame.midX + (i == 0 ? 50 : -50),
                            y: self.frame.maxY - 5)
                    
                    let line = UIBezierPath()
                    let origin = antenna.element.frame.origin
                    line.move(to: CGPoint(x: origin.x + 5, y: origin.y + 5))
                    line.addLine(to: CGPoint(x: nodeOrigin.x + 5, y: nodeOrigin.y + 5))
                    antennaLines[offset][i].strokeColor = UIColor.clear.cgColor
                    antennaLines[offset][i].path = line.cgPath
                }
                
                thetaTwo.sizeToFit()
                var h: CGFloat = 0
                var a: CGFloat = 0
                
                if CGPointDistance(from: nodeOrigin, to: $0.element[0].frame.origin) > CGPointDistance(from: nodeOrigin, to: $0.element[1].frame.origin){
                    h = CGPointDistance(from: nodeOrigin, to: $0.element[0].frame.origin)
                    a = sqrt(pow(nodeOrigin.x - $0.element[0].frame.origin.x, 2))
                    antennaLines[offset][0].strokeColor = UIColor.green.cgColor
                    thetaTwo.frame.origin = CGPoint(x: $0.element[0].frame.origin.x + 10, y: $0.element[0].frame.origin.y - thetaTwo.frame.height - 10)
                }
                else{
                    h = CGPointDistance(from: nodeOrigin, to: $0.element[1].frame.origin)
                    a = sqrt(pow(nodeOrigin.x - $0.element[1].frame.origin.x, 2))
                    antennaLines[offset][1].strokeColor = UIColor.green.cgColor
                    thetaTwo.frame.origin = CGPoint(x: $0.element[1].frame.origin.x - 10 - thetaTwo.frame.width, y: $0.element[1].frame.origin.y - thetaTwo.frame.height - 10)
                }
                
                let theta = round((acos(a/h)*180/CGFloat.pi)*100)/100
                thetaTwo.text = "Theta = \(theta)"
                 
            case 2:
                let offset = 2
                $0.element.enumerated().forEach{ antenna in
                    let i = antenna.offset
                    antenna.element.frame.origin =
                        CGPoint(
                            x: -5,
                            y: self.frame.midY + (i == 0 ? 50 : -50))
                    
                    let line = UIBezierPath()
                    let origin = antenna.element.frame.origin
                    line.move(to: CGPoint(x: origin.x + 5, y: origin.y + 5))
                    line.addLine(to: CGPoint(x: nodeOrigin.x + 5, y: nodeOrigin.y + 5))
                    antennaLines[offset][i].strokeColor = UIColor.clear.cgColor
                    antennaLines[offset][i].path = line.cgPath
                }
                
                thetaThree.sizeToFit()
                var h: CGFloat = 0
                var a: CGFloat = 0
                
                if CGPointDistance(from: nodeOrigin, to: $0.element[0].frame.origin) > CGPointDistance(from: nodeOrigin, to: $0.element[1].frame.origin){
                    h = CGPointDistance(from: nodeOrigin, to: $0.element[0].frame.origin)
                    a = sqrt(pow(nodeOrigin.y - $0.element[0].frame.origin.y, 2))
                    antennaLines[offset][0].strokeColor = UIColor.green.cgColor
                    thetaThree.frame.origin = CGPoint(x: $0.element[0].frame.origin.x + 10, y: $0.element[0].frame.origin.y + 10)
                }
                else{
                    antennaLines[offset][1].strokeColor = UIColor.green.cgColor
                    h = CGPointDistance(from: nodeOrigin, to: $0.element[1].frame.origin)
                    a = sqrt(pow(nodeOrigin.y - $0.element[1].frame.origin.y, 2))
                    thetaThree.frame.origin = CGPoint(x: $0.element[1].frame.origin.x + 10, y: $0.element[1].frame.origin.y - 10 - thetaThree.frame.height)
                }
                
                let theta = round((acos(a/h)*180/CGFloat.pi)*100)/100
                thetaThree.text = "Theta = \(theta)"
                
            case 3:
                let offset = 3
                $0.element.enumerated().forEach{ antenna in
                    let i = antenna.offset
                    antenna.element.frame.origin =
                        CGPoint(
                            x: self.frame.maxX - 5,
                            y: self.frame.midY + (i == 0 ? 50 : -50))
                    
                    let line = UIBezierPath()
                    let origin = antenna.element.frame.origin
                    line.move(to: CGPoint(x: origin.x + 5, y: origin.y + 5))
                    line.addLine(to: CGPoint(x: nodeOrigin.x + 5, y: nodeOrigin.y + 5))
                    antennaLines[offset][i].strokeColor = UIColor.clear.cgColor
                    antennaLines[offset][i].path = line.cgPath
                }
                
                thetaFour.sizeToFit()
                var h: CGFloat = 0
                var a: CGFloat = 0
                
                if CGPointDistance(from: nodeOrigin, to: $0.element[0].frame.origin) > CGPointDistance(from: nodeOrigin, to: $0.element[1].frame.origin){
                    h = CGPointDistance(from: nodeOrigin, to: $0.element[0].frame.origin)
                    a = sqrt(pow(nodeOrigin.y - $0.element[0].frame.origin.y, 2))
                    antennaLines[offset][0].strokeColor = UIColor.green.cgColor
                    thetaFour.frame.origin = CGPoint(x: $0.element[0].frame.origin.x - thetaFour.frame.width - 10, y: $0.element[0].frame.origin.y + 10)
                }
                else{
                    h = CGPointDistance(from: nodeOrigin, to: $0.element[1].frame.origin)
                    a = sqrt(pow(nodeOrigin.y - $0.element[1].frame.origin.y, 2))
                    antennaLines[offset][1].strokeColor = UIColor.green.cgColor
                    thetaFour.frame.origin = CGPoint(x: $0.element[1].frame.origin.x - thetaFour.frame.width - 10, y: $0.element[1].frame.origin.y - 10 - thetaFour.frame.height)
                }
                
                let theta = round((acos(a/h)*180/CGFloat.pi)*100)/100
                thetaFour.text = "Theta = \(theta)"
                
            default:break
                
            }
        }
        
        //nodeOrigin = CGPoint(x: self.frame.midX, y: self.frame.midY)
    }
    
    func CGPointDistanceSquared(from: CGPoint, to: CGPoint) -> CGFloat {
        return (from.x - to.x) * (from.x - to.x) + (from.y - to.y) * (from.y - to.y)
    }

    func CGPointDistance(from: CGPoint, to: CGPoint) -> CGFloat {
        return sqrt(CGPointDistanceSquared(from: from, to: to))
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        print(point)
        nodeOrigin = point
        
        pulseArray.forEach{
            $0.frame.origin = nodeOrigin
        }
        layoutSubviews()
        return self
    }
    
}


import UIKit
import PlaygroundSupport

class ViewController : UIViewController {

    override func loadView() {

        // UI
        //self.view.frame = CGRect(origin: .zero, size: CGSize(width: 300, height: 300))
        let view = ActionView()
        self.view = view
    }

}
let vc = ViewController()
vc.preferredContentSize = CGSize(width: 600, height: 600)
PlaygroundPage.current.liveView = vc
