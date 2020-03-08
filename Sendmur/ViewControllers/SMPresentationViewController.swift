//
//  SMPresentationViewController.swift
//  Sendmur
//
//  Created by Angel Fuentes on 16/09/2019.
//  Copyright © 2019 Angel Fuentes. All rights reserved.
//

import UIKit

final class SMPresentationViewController: SMViewController {

    private enum CardState {
        case expanded
        case collapsed
    }
    
    private var cardIsVisible: Bool = false
    private var nextState: CardState {
        return cardIsVisible ? .collapsed : .expanded
    }
    
    private var runningAnimations = [UIViewPropertyAnimator]()
    
    var statusBarStyle: UIStatusBarStyle = .default {
        didSet {
            setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return statusBarStyle
    }
    
    private let viewController = SMSignupViewController()
    private var cardViewController = SMLoginViewController()
    private var cardHiddenConstraint: NSLayoutConstraint!
    private var cardVisibleConstraint: NSLayoutConstraint!
    private var animationProgressWhenInterrupted: CGFloat = 0.0
    private let cardTitleHeight: CGFloat = 120
    private let duration: TimeInterval = 0.3
    
    private let dimmedView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(white: 0, alpha: 0.5)
        view.alpha = 0
        return view
    }()
    
    override func setupNavigation() {
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addChild(viewController)
        let viewControllerView = viewController.view!
        viewControllerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(viewControllerView)
        let viewControllerViewConstraints = [
            viewControllerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            viewControllerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            viewControllerView.topAnchor.constraint(equalTo: view.topAnchor),
            viewControllerView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        NSLayoutConstraint.activate(viewControllerViewConstraints)
        viewController.didMove(toParent: self)
        
        view.addSubview(dimmedView)
        let dimmedViewConstraints = [
            dimmedView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            dimmedView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            dimmedView.topAnchor.constraint(equalTo: view.topAnchor),
            dimmedView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        NSLayoutConstraint.activate(dimmedViewConstraints)
        
        addChild(cardViewController)
        let cardViewControllerView = cardViewController.view!
        cardViewControllerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(cardViewControllerView)
        
        cardHiddenConstraint = cardViewControllerView.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -cardTitleHeight)
        cardVisibleConstraint = cardViewControllerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 60)
        
        let cardViewControllerViewConstraints = [
            cardViewControllerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            cardViewControllerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            cardHiddenConstraint!,
            cardViewControllerView.heightAnchor.constraint(equalTo: view.heightAnchor, constant: UIScreen.main.bounds.height - 60)
        ]
        NSLayoutConstraint.activate(cardViewControllerViewConstraints)
        cardViewController.didMove(toParent: self)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
        cardViewController.pullUpView.addGestureRecognizer(tapGestureRecognizer)
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePresentPanGesture(gestureRecognizer:)))
        cardViewController.pullUpView.addGestureRecognizer(panGestureRecognizer)
    }
    
    // MARK: Actions
    @objc private func handleTapGesture(_ gestureRecognizer: UITapGestureRecognizer) {
        animateTransitionIfNeeded(state: nextState, duration: duration)
    }
    
    @objc private func handlePresentPanGesture(gestureRecognizer: UIPanGestureRecognizer) {
        switch gestureRecognizer.state {
        case .began:
            startInteractiveTransition(state: nextState, duration: duration)
        case .changed:
            let translation = gestureRecognizer.translation(in: self.cardViewController.view)
            var fractionComplete = translation.y / (view.bounds.height - cardTitleHeight)
            fractionComplete = cardIsVisible ? fractionComplete : -fractionComplete
            updateInteractiveTransition(fractionComplete: fractionComplete)
        case .ended:
            continueInteractiveTransition()
        default:
            break
        }
    }
    
    // MARK: Private
    private func animateTransitionIfNeeded(state: CardState, duration: TimeInterval) {
        guard runningAnimations.isEmpty else { return }
        
        let frameAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
            switch state {
            case .expanded:
                self.cardHiddenConstraint.isActive = false
                self.cardVisibleConstraint.isActive = true
                self.view.layoutIfNeeded()
            case .collapsed:
                self.cardVisibleConstraint.isActive = false
                self.cardHiddenConstraint.isActive = true
                self.view.layoutIfNeeded()
            }
        }
        frameAnimator.addCompletion { _ in
            self.cardIsVisible = !self.cardIsVisible
            self.runningAnimations.removeAll()
        }
        frameAnimator.startAnimation()
        runningAnimations.append(frameAnimator)
        
        let transformAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
            switch state {
            case .expanded:
                self.viewController.view.transform = CGAffineTransform(scaleX: 0.90, y: 0.90)
                self.viewController.view.layer.cornerRadius = 15
            case .collapsed:
                self.viewController.view.transform = .identity
                self.viewController.view.layer.cornerRadius = 0
            }
        }
        transformAnimator.startAnimation()
        runningAnimations.append(transformAnimator)
        
        let statusBarAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
            switch state {
            case .expanded:
                self.statusBarStyle = .lightContent
            case .collapsed:
                self.statusBarStyle = .default
            }
        }
        statusBarAnimator.startAnimation()
        runningAnimations.append(statusBarAnimator)
        
        let dimmedViewAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
            switch state {
            case .expanded:
                self.dimmedView.alpha = 1
            case .collapsed:
                self.dimmedView.alpha = 0
            }
        }
        dimmedViewAnimator.startAnimation()
        runningAnimations.append(dimmedViewAnimator)
        
        let roundedCornersAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
            switch state {
            case .expanded:
                self.cardViewController.view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
                self.cardViewController.view.layer.cornerRadius = 15.0
                self.cardViewController.view.layer.masksToBounds = true
                self.cardViewController.pullUpView.label.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
                self.cardViewController.pullUpView.label.alpha = 1
                self.cardViewController.pullUpView.viewWrapper.layer.shadowOpacity = 0
            case .collapsed:
                self.cardViewController.view.layer.cornerRadius = 0
                self.cardViewController.pullUpView.label.transform = CGAffineTransform(scaleX: 0.3, y: 0.3)
                self.cardViewController.pullUpView.label.alpha = 0.3
                self.cardViewController.pullUpView.viewWrapper.layer.shadowOpacity = 0.2
            }
        }
        roundedCornersAnimator.startAnimation()
        runningAnimations.append(roundedCornersAnimator)
    }
    
    private func startInteractiveTransition(state: CardState, duration: TimeInterval) {
        if runningAnimations.isEmpty {
            animateTransitionIfNeeded(state: state, duration: duration)
        }
        for animator in runningAnimations {
            animator.pauseAnimation()
            animationProgressWhenInterrupted = animator.fractionComplete
        }
    }
    
    private func updateInteractiveTransition(fractionComplete: CGFloat) {
        for animator in runningAnimations {
            animator.fractionComplete = fractionComplete + animationProgressWhenInterrupted
        }
    }
    
    private func continueInteractiveTransition() {
        for animator in runningAnimations {
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        }
    }
}
