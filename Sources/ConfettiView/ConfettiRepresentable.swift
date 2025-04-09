//
//  ConfettiRepresentable.swift
//  UnionConfetti
//
//  Created by Benjamin Sage on 12/15/24.
//

import Foundation
import SwiftUI

struct ConfettiRepresentable: UIViewRepresentable {
    @Binding var isPresented: Bool

    func makeUIView(context: Context) -> ConfettiUIView {
        let view = ConfettiUIView()
        view.isUserInteractionEnabled = false
        return view
    }

    func updateUIView(_ uiView: ConfettiUIView, context: Context) {
        if isPresented {
            uiView.startConfetti {
                DispatchQueue.main.async {
                    self.isPresented = false
                }
            }
        }
    }
}

class ConfettiUIView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        isUserInteractionEnabled = false
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = .clear
        isUserInteractionEnabled = false
    }

    private func createConfettiLayer() -> CAEmitterLayer {
        let emitterLayer = CAEmitterLayer()
        emitterLayer.emitterCells = confettiCells
        emitterLayer.emitterPosition = CGPoint(x: bounds.midX, y: bounds.midY)
        emitterLayer.emitterSize = CGSize(width: 100, height: 100)
        emitterLayer.emitterShape = .sphere
        emitterLayer.frame = bounds
        emitterLayer.birthRate = 0
        emitterLayer.beginTime = CACurrentMediaTime()
        return emitterLayer
    }

    private func createConfettiLayer2() -> CAEmitterLayer {
        let emitterLayer = CAEmitterLayer()
        emitterLayer.emitterCells = confettiCells.map { cell in
            let newCell = cell.copy() as! CAEmitterCell
            newCell.scale = 0.5
            return newCell
        }
        emitterLayer.emitterPosition = CGPoint(x: bounds.midX, y: bounds.midY)
        emitterLayer.emitterSize = CGSize(width: 100, height: 100)
        emitterLayer.emitterShape = .sphere
        emitterLayer.frame = bounds
        emitterLayer.birthRate = 0
        emitterLayer.opacity = 0.5
        emitterLayer.speed = 0.95
        emitterLayer.beginTime = CACurrentMediaTime()
        return emitterLayer
    }

    lazy var confettiCells: [CAEmitterCell] = {
        return confettiTypes.map { confettiType in
            let cell = CAEmitterCell()

            cell.beginTime = 0.1
            cell.birthRate = 100
            cell.contents = confettiType.image.cgImage
            cell.emissionRange = CGFloat(Double.pi)
            cell.lifetime = 10
            cell.spin = 4
            cell.spinRange = 8
            cell.velocityRange = 0
            cell.yAcceleration = 0

            cell.setValue("plane", forKey: "particleType")
            cell.setValue(Double.pi, forKey: "orientationRange")
            cell.setValue(Double.pi / 2, forKey: "orientationLongitude")
            cell.setValue(Double.pi / 2, forKey: "orientationLatitude")

            cell.name = confettiType.name

            return cell
        }
    }()

    func addBirthrateAnimation(to layer: CALayer) {
        let animation = CABasicAnimation()
        animation.duration = 1
        animation.fromValue = 1
        animation.toValue = 0

        layer.add(animation, forKey: "birthRate")
    }

    private func addAnimations(to confettiLayer: CAEmitterLayer, and confettiLayer2: CAEmitterLayer) {
        addAttractorAnimation(to: confettiLayer)
        addBirthrateAnimation(to: confettiLayer)
        addDragAnimation(to: confettiLayer)
        addGravityAnimation(to: confettiLayer)

        addAttractorAnimation(to: confettiLayer2)
        addBirthrateAnimation(to: confettiLayer2)
        addDragAnimation(to: confettiLayer2)
        addGravityAnimation(to: confettiLayer2)
    }

    func startConfetti(completion: @escaping () -> Void) {
        setupConfetti()
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.layer.sublayers?.removeAll(where: { $0 is CAEmitterLayer })
            completion()
        }
    }

    private func setupConfetti() {
        let confettiLayer = createConfettiLayer()
        let confettiLayer2 = createConfettiLayer2()

        layer.addSublayer(confettiLayer2)
        layer.addSublayer(confettiLayer)
        addBehaviors(to: confettiLayer, and: confettiLayer2)
        addAnimations(to: confettiLayer, and: confettiLayer2)
    }

    func horizontalWaveBehavior() -> NSObject {
        let behavior = createBehavior(type: "wave")
        behavior.setValue([100, 0, 0], forKeyPath: "force")
        behavior.setValue(0.5, forKeyPath: "frequency")
        return behavior
    }

    func verticalWaveBehavior() -> NSObject {
        let behavior = createBehavior(type: "wave")
        behavior.setValue([0, 500, 0], forKeyPath: "force")
        behavior.setValue(3, forKeyPath: "frequency")
        return behavior
    }

    private func addBehaviors(to confettiLayer: CAEmitterLayer, and confettiLayer2: CAEmitterLayer) {
        confettiLayer.setValue([
            horizontalWaveBehavior(),
            verticalWaveBehavior(),
            attractorBehavior(for: confettiLayer),
            dragBehavior()
        ], forKey: "emitterBehaviors")
        confettiLayer2.setValue([
            horizontalWaveBehavior(),
            verticalWaveBehavior(),
            attractorBehavior(for: confettiLayer2),
            dragBehavior()
        ], forKey: "emitterBehaviors")
    }

    func createBehavior(type: String) -> NSObject {
        guard let behaviorClass = NSClassFromString("CAEmitterBehavior") as? NSObject.Type,
              let behaviorWithType = behaviorClass.method(for: NSSelectorFromString("behaviorWithType:")) else {
            return .init()
        }
        let castedBehaviorWithType = unsafeBitCast(
            behaviorWithType,
            to: (
                @convention(c)(Any?, Selector, Any?) -> NSObject
            ).self
        )
        return castedBehaviorWithType(behaviorClass, NSSelectorFromString("behaviorWithType:"), type)
    }

    func attractorBehavior(for emitterLayer: CAEmitterLayer) -> NSObject {
        let behavior = createBehavior(type: "attractor")

        behavior.setValue(-290, forKeyPath: "falloff")
        behavior.setValue(300, forKeyPath: "radius")
        behavior.setValue(10, forKeyPath: "stiffness")

        behavior.setValue(CGPoint(x: emitterLayer.emitterPosition.x,
                                  y: emitterLayer.emitterPosition.y + 20),
                          forKeyPath: "position")
        behavior.setValue(-70, forKeyPath: "zPosition")
        behavior.setValue("attractor", forKeyPath: "name")

        return behavior
    }

    func addAttractorAnimation(to layer: CALayer) {
        let animation = CAKeyframeAnimation()
        animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        animation.duration = 3
        animation.keyTimes = [0, 0.4]
        animation.values = [80, 5]

        layer.add(animation, forKey: "emitterBehaviors.attractor.stiffness")
    }

    func dragBehavior() -> NSObject {
        let behavior = createBehavior(type: "drag")
        behavior.setValue("drag", forKey: "name")
        behavior.setValue(2, forKey: "drag")

        return behavior
    }

    func addDragAnimation(to layer: CALayer) {
        let animation = CABasicAnimation()
        animation.duration = 0.35
        animation.fromValue = 0
        animation.toValue = 2

        layer.add(animation, forKey:  "emitterBehaviors.drag.drag")
    }

    func addGravityAnimation(to layer: CALayer) {
        let animation = CAKeyframeAnimation()
        animation.duration = 6
        animation.keyTimes = [0.05, 0.1, 0.5, 1]
        animation.values = [0, 100, 2000, 4000]

        for image in confettiTypes {
            layer.add(animation, forKey: "emitterCells.\(image.name).yAcceleration")
        }
    }

    lazy var confettiTypes: [ConfettiType] = {
        let confettiColors = [
            (r:149,g:58,b:255), (r:255,g:195,b:41), (r:255,g:101,b:26),
            (r:123,g:92,b:255), (r:76,g:126,b:255), (r:71,g:192,b:255),
            (r:255,g:47,b:39), (r:255,g:91,b:134), (r:233,g:122,b:208)
            ].map { UIColor(red: $0.r / 255.0, green: $0.g / 255.0, blue: $0.b / 255.0, alpha: 1) }

        return [ConfettiPosition.foreground, ConfettiPosition.background].flatMap { position in
            return [ConfettiShape.rectangle, ConfettiShape.circle].flatMap { shape in
                return confettiColors.map { color in
                    return ConfettiType(color: color, shape: shape, position: position)
                }
            }
        }
    }()

    class ConfettiType {
        let color: UIColor
        let shape: ConfettiShape
        let position: ConfettiPosition

        lazy var name = UUID().uuidString

        lazy var image: UIImage = {
            let imageRect: CGRect = {
                switch shape {
                case .rectangle:
                    return CGRect(x: 0, y: 0, width: 20, height: 13)
                case .circle:
                    return CGRect(x: 0, y: 0, width: 10, height: 10)
                }
            }()

            UIGraphicsBeginImageContext(imageRect.size)
            let context = UIGraphicsGetCurrentContext()!
            context.setFillColor(color.cgColor)

            switch shape {
            case .rectangle:
                context.fill(imageRect)
            case .circle:
                context.fillEllipse(in: imageRect)
            }

            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return image!
        }()

        init(color: UIColor, shape: ConfettiShape, position: ConfettiPosition) {
            self.color = color
            self.shape = shape
            self.position = position
        }
    }

    enum ConfettiShape {
        case rectangle
        case circle
    }

    enum ConfettiPosition {
        case foreground
        case background
    }
}
