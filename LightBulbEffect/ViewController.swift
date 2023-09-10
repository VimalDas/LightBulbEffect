//
//  ViewController.swift
//  LightBulbEffect
//
//  Created by Vimal Das on 10/09/23.
//

import UIKit

class ViewController: UIViewController {
    private let text = """
    Thoughts of you surround me. You're the beating of my heart. The love you give defines me. My life is no longer dark.
    You give your hand so sweetly.I am lost if you're away.You have me so completely.I cherish you night and day.
    Without your breath, I cannot live.I need your lips on mine.Nothing at all I wouldn't give.I'll take nothing and be fine.
    For in your arms I'm always home,So happy and so proud.Never a day you'll feel alone,And I'll yell it oh so loud...

    I LOVE YOU WITH ALL MY HEART!
    Thoughts of you surround me. You're the beating of my heart. The love you give defines me. My life is no longer dark.
    You give your hand so sweetly.I am lost if you're away.You have me so completely.I cherish you night and day.
    Without your breath, I cannot live.I need your lips on mine.Nothing at all I wouldn't give.I'll take nothing and be fine.
    For in your arms I'm always home,So happy and so proud.Never a day you'll feel alone,And I'll yell it oh so loud...

    I LOVE YOU WITH ALL MY HEART!
    Thoughts of you surround me. You're the beating of my heart. The love you give defines me. My life is no longer dark.
    You give your hand so sweetly.I am lost if you're away.You have me so completely.I cherish you night and day.
    Without your breath, I cannot live.I need your lips on mine.Nothing at all I wouldn't give.I'll take nothing and be fine.
    For in your arms I'm always home,So happy and so proud.Never a day you'll feel alone,And I'll yell it oh so loud...

    I LOVE YOU WITH ALL MY HEART!
    Thoughts of you surround me. You're the beating of my heart. The love you give defines me. My life is no longer dark.
    You give your hand so sweetly.I am lost if you're away.You have me so completely.I cherish you night and day.
    Without your breath, I cannot live.I need your lips on mine.Nothing at all I wouldn't give.I'll take nothing and be fine.
    For in your arms I'm always home,So happy and so proud.Never a day you'll feel alone,And I'll yell it oh so loud...

    I LOVE YOU WITH ALL MY HEART!
    """
    
    private var initialHeight: CGFloat = 200
    private var isOn = false {
        didSet {
            overlayTextView.textColor = isOn ? .white : .darkGray
            bulb.tintColor = isOn ? .white : .gray
            toggleFlashlight()
        }
    }
    
    private var flashLightView: UIView = {
        let viw = UIView()
        viw.translatesAutoresizingMaskIntoConstraints = false
        viw.widthAnchor.constraint(equalToConstant: 400).isActive = true
        viw.heightAnchor.constraint(equalToConstant: 400).isActive = true
        return viw
    }()
    
    private var wireView: UIView = {
        let viw = UIView()
        viw.backgroundColor = .orange
        return viw
    }()
    
    private var bulb: UIImageView = {
        let imgView = UIImageView()
        imgView.image = UIImage(named: "lightBulb")
        imgView.tintColor = .gray
        imgView.isUserInteractionEnabled = true
        imgView.transform = CGAffineTransform(rotationAngle: .pi)
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        imgView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        return imgView
    }()
    
    private var textView: UITextView = {
        let txtView = UITextView()
        txtView.backgroundColor = .clear
        txtView.font = UIFont.systemFont(ofSize: 20)
        txtView.textColor = .darkGray
        return txtView
    }()
    
    private var overlayTextView: UITextView = {
        let txtView = UITextView()
        txtView.backgroundColor = .clear
        txtView.font = UIFont.systemFont(ofSize: 20)
        txtView.textColor = .white
        return txtView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .black
        
        view.addSubview(textView)
        textView.frame = view.bounds
        textView.text = text

        view.addSubview(overlayTextView)
        overlayTextView.frame = view.bounds
        overlayTextView.text = text

        view.addSubview(wireView)
        wireView.frame = CGRect(origin: CGPoint(x: view.bounds.width/2, y: 0), size: CGSize(width: 5, height: 200))
        
        view.addSubview(flashLightView)
        flashLightView.layer.cornerRadius = flashLightView.bounds.width/2
        flashLightView.layer.masksToBounds = true
//        let blurEffect = UIBlurEffect(style: .light)
//        let blurView = UIVisualEffectView(effect: blurEffect)
//        blurView.frame = flashLightView.bounds
//        flashLightView.addSubview(blurView)
        
        view.addSubview(bulb)
        bulb.centerXAnchor.constraint(equalTo: wireView.centerXAnchor).isActive = true
        bulb.topAnchor.constraint(equalTo: wireView.bottomAnchor).isActive = true
        
        flashLightView.centerXAnchor.constraint(equalTo: bulb.centerXAnchor).isActive = true
        flashLightView.centerYAnchor.constraint(equalTo: bulb.centerYAnchor).isActive = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap(_:)))
        bulb.addGestureRecognizer(tapGesture)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        bulb.addGestureRecognizer(panGesture)
        
        updateFlashlight()
    }
    
    @objc func handleTap(_ recognizer: UITapGestureRecognizer) {
        isOn = !isOn
    }
    
    @objc func handlePan(_ recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: bulb)
        
        // Calculate the new width based on the pan gesture's translation
        let newHeight = initialHeight + (-translation.y)
        
        // Apply rubber band effect by adjusting the new width
        let rubberBandedHeight = max(50, min(newHeight, 1400)) // Adjust the minimum and maximum width as desired
        
        // Update the line view's width
        wireView.frame.size.height = rubberBandedHeight
        updateFlashlight()
        // Reset the translation to prevent continuous growth
        //recognizer.setTranslation(.zero, in: bulb)
        if recognizer.state == .ended {
            // Add a spring animation for the rubber band effect
            UIView.animate(withDuration: 0.5,
                           delay: 0,
                           usingSpringWithDamping: 0.5,
                           initialSpringVelocity: 0.2,
                           options: [],
                           animations: {
                            self.wireView.frame.size.height = self.initialHeight
                            self.resetFlashlight()
                            
                            self.view.layoutSubviews()
                           })
        }
    }
    
    private func updateFlashlight() {
        let maskLayer = CAShapeLayer()
        maskLayer.frame = overlayTextView.bounds
        let flashlightPath = UIBezierPath(ovalIn: flashLightView.frame)
        maskLayer.path = flashlightPath.cgPath
        overlayTextView.layer.mask = maskLayer
    }
    
    private func resetFlashlight() {
        let maskLayer = CAShapeLayer()
        maskLayer.frame = overlayTextView.bounds
        let flashlightPath = UIBezierPath(ovalIn: CGRect(x: 207.5, y: 30, width: 400, height: 400))
        maskLayer.path = flashlightPath.cgPath
        overlayTextView.layer.mask = maskLayer
    }
    
    private func toggleFlashlight() {
        if overlayTextView.layer.mask == nil {
            UIView.animate(withDuration: 0, delay: 0.5) {
                self.updateFlashlight()
            }
        } else {
            overlayTextView.layer.mask = nil
        }
    }
}
