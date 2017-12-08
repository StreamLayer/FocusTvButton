//
//  FocusTvButton.swift
//  FocusTvButton
//
//  Created by David Cordero on 01/09/16.
//  Copyright © 2016 David Cordero, Inc. All rights reserved.
//

import UIKit


open class FocusTvButton: UIButton {
    
    @IBInspectable public var focusedBackgroundColor: UIColor = .red {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable public var focusedBackgroundEndColor: UIColor? {
        didSet {
            updateView()
        }
    }
    
    @IBInspectable public var normalBackgroundColor: UIColor = .white {
        didSet {
            updateView()
        }
    }
    @IBInspectable public var normalBackgroundEndColor: UIColor? {
        didSet {
            updateView()
        }
    }
    @IBInspectable public var cornerRadius: CGFloat = 5.0 {
        didSet {
            self.updateView()
        }
    }
    
    @IBInspectable public var focusedScaleFactor: CGFloat = 1.2 {
        didSet {
            self.updateView()
        }
    }
    
    @IBInspectable public var focusedShadowRadius: CGFloat = 10 {
        didSet {
            self.updateView()
        }
    }
    @IBInspectable public var focusedShadowOpacity: Float = 0.25 {
        didSet {
            self.updateView()
        }
    }
    
    @IBInspectable public var shadowColor: CGColor = UIColor.black.cgColor {
        didSet {
            self.updateView()
        }
    }
    
    @IBInspectable public var shadowOffSetFocused: CGSize = CGSize(width: 0, height: 27) {
        didSet {
            self.updateView()
        }
    }
    
    @IBInspectable public var animationDuration: TimeInterval = 0.2 {
        didSet {
            self.updateView()
        }
    }
    
    @IBInspectable public var focusedTitleColor: UIColor = .white {
        didSet {
            self.updateView()
        }
    }
    @IBInspectable public var normalTitleColor: UIColor = .white {
        didSet {
            self.updateView()
        }
    }
    
    @IBInspectable public var gradientStartPoint: CGPoint = .zero {
        didSet {
            self.updateView()
        }
    }
    
    @IBInspectable public var gradientEndPoint: CGPoint = CGPoint(x: 1, y: 1) {
        didSet {
            self.updateView()
        }
    }
    
    open override var buttonType: UIButtonType {
        return .custom
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        updateView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        updateView()
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        updateView()
    }
    
    override open func didUpdateFocus(in context: UIFocusUpdateContext, with coordinator: UIFocusAnimationCoordinator) {
        coordinator.addCoordinatedAnimations({
            self.isFocused ? self.applyFocusedStyle() : self.applyUnfocusedStyle()
        }, completion: nil)
    }
    
    override open func pressesBegan(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        guard presses.first?.type == .select else {
            return super.pressesBegan(presses, with: event)
        }
        
        UIView.animate(
            withDuration: animationDuration,
            animations: {
                [weak self] in
                guard let `self` = self else { return }
                self.transform = CGAffineTransform.identity
                self.layer.shadowOffset = CGSize(width: 0, height: 10)
        })
    }
    
    override open func pressesCancelled(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        guard presses.first?.type == .select else {
            return super.pressesCancelled(presses, with: event)
        }
        guard isFocused else { return }
        UIView.animate(
            withDuration: animationDuration,
            animations: {
                [weak self] in
                guard let `self` = self else { return }
                self.transform = CGAffineTransform(scaleX: self.focusedScaleFactor, y: self.focusedScaleFactor)
                self.layer.shadowOffset = self.shadowOffSetFocused
        })
    }
    
    override open func pressesEnded(_ presses: Set<UIPress>, with event: UIPressesEvent?) {
        guard presses.first?.type == .select else {
            return super.pressesEnded(presses, with: event)
        }
        guard isFocused else { return }
        UIView.animate(
            withDuration: animationDuration,
            animations: {
                [weak self] in
                guard let `self` = self else { return }
                self.transform = CGAffineTransform(scaleX: self.focusedScaleFactor, y: self.focusedScaleFactor)
                self.layer.shadowOffset = self.shadowOffSetFocused
        })
    }
    
    // MARK: - Private
    
    private var focusedGradientBackgroundColors: [CGColor] {
        let endColor = focusedBackgroundEndColor ?? focusedBackgroundColor
        return [focusedBackgroundColor.cgColor, endColor.cgColor]
    }
    
    private var normalGradientBackgroundColors: [CGColor] {
        let endColor = normalBackgroundEndColor ?? normalBackgroundColor
        return [normalBackgroundColor.cgColor, endColor.cgColor]
    }
    
    private let gradientView = GradientView()
    
    private func updateView() {
        setUpGradientView()
        layer.cornerRadius = cornerRadius
        clipsToBounds = true
        setTitleColor(normalTitleColor, for: .normal)
        setTitleColor(focusedTitleColor, for: .focused)
        layer.shadowOpacity = focusedShadowOpacity
        layer.shadowRadius = focusedShadowRadius
        layer.shadowColor = shadowColor
        layer.shadowOffset = shadowOffSetFocused
        
        if isFocused {
            transform = CGAffineTransform(scaleX: self.focusedScaleFactor, y: self.focusedScaleFactor)
        }
        else {
            self.transform = CGAffineTransform.identity
        }
    }
    
    private func setUpGradientView() {
        gradientView.frame = bounds
        gradientView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        gradientView.layer.cornerRadius = cornerRadius
        gradientView.startPoint = gradientStartPoint
        gradientView.endPoint = gradientEndPoint
        
        if isFocused {
            gradientView.colors = self.focusedGradientBackgroundColors
        }
        else {
            gradientView.colors = normalGradientBackgroundColors
        }
        
        if let imageView = imageView {
            insertSubview(gradientView, belowSubview: imageView)
        }
        else if let titleLabel = titleLabel {
            insertSubview(gradientView, belowSubview: titleLabel)
        }
        else {
            addSubview(gradientView)
        }
    }
    
    private func applyFocusedStyle() {
        UIView.animate(
            withDuration: animationDuration,
            animations: {
                [weak self] in
                self?.updateView()
            },
            completion: nil)
    }
    
    private func applyUnfocusedStyle() {
        UIView.animate(
            withDuration: animationDuration,
            animations: {
                [weak self] in
                self?.updateView()
            },
            completion: nil)
    }
}

final private class GradientView: UIView {
    
    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    var colors: [Any]? {
        set {
            gradientLayer.colors = newValue
        }
        
        get {
            return gradientLayer.colors
        }
    }
    
    var startPoint: CGPoint {
        set {
            gradientLayer.startPoint = newValue
        }
        
        get {
            return gradientLayer.startPoint
        }
    }
    
    var endPoint: CGPoint {
        set {
            gradientLayer.endPoint = newValue
        }
        
        get {
            return gradientLayer.endPoint
        }
    }
    
    // MARK: - Private
    
    private lazy var gradientLayer: CAGradientLayer = {
        return self.layer as! CAGradientLayer
    }()
}
