//
//  ViewController.swift
//  MoveMe
//
//  Created by Ashwin D'Silva on 06/03/21.
//

import UIKit

class ViewController: UIViewController {
  
  // MARK: - Views
  private lazy var card: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.image = #imageLiteral(resourceName: "panda")
    imageView.backgroundColor = #colorLiteral(red: 0.3058823529, green: 0.6156862745, blue: 0.662745098, alpha: 1)
    imageView.contentMode = .scaleAspectFit
    imageView.layer.cornerRadius = 10
    imageView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(panCard(_:))))
    imageView.isUserInteractionEnabled = true
    return imageView
  }()
  
  // MARK: - Properties
  private var dynamicAnimator: UIDynamicAnimator!
  private var snapBehavior: UISnapBehavior!
  
  // MARK: - Lifecycle
  override func viewDidLoad() {
    super.viewDidLoad()
    initialSetup()
  }
}

// MARK: - Helpers
extension ViewController {
  func initialSetup() {
    view.backgroundColor = .systemBackground
    configureCard()
    configureDynamics()
  }
  
  func configureCard() {
    view.addSubview(card)
    
    NSLayoutConstraint.activate([
      card.centerYAnchor.constraint(equalTo: view.centerYAnchor),
      card.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      card.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
      card.heightAnchor.constraint(equalTo: card.widthAnchor, multiplier: 1.5)
    ])
    
    view.layoutIfNeeded()
  }
  
  func configureDynamics() {
    dynamicAnimator = UIDynamicAnimator(referenceView: view)
    snapBehavior = UISnapBehavior(item: card, snapTo: view.center)
    dynamicAnimator.addBehavior(snapBehavior)
  }
  
  @objc
  func panCard(_ gestureRecogniser: UIPanGestureRecognizer) {
    switch gestureRecogniser.state {
    case  .began:
      // Remove the snap behavior so that it doesn't interfere with the pan gesture
      dynamicAnimator.removeBehavior(snapBehavior)
      
    case .changed:
      let translation = gestureRecogniser.translation(in: view)
      
      // Move card's center according to the translation
      card.center = CGPoint(x: card.center.x + translation.x, y: card.center.y + translation.y)
      
      // Since translation(in:) doesn't provide delta values, reset the translation
      gestureRecogniser.setTranslation(.zero, in: view)
      
    case .ended:
      dynamicAnimator.addBehavior(snapBehavior)
    default:
      break
    }
  }
}

