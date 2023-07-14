//
//  ViewController.swift
//  vorobei-challange-1
//
//  Created by Alexey Voronov on 03.07.2023.
//

import UIKit

class ViewController: UIViewController {
    let button = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        button.addAction(.init(handler: { _ in
            self.showMenu(fromPoint: CGPoint(x: self.button.center.x,
                                             y: self.button.center.y + self.button.frame.height/2))
            
        }), for: .touchUpInside)
        
        self.view.addSubview(button)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Present", for: .normal)
        
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    func showMenu(fromPoint: CGPoint) {
        let vc = AlertViewController(fromPoint: fromPoint)
        vc.modalPresentationStyle = .overFullScreen
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true)
    }
}

class AlertViewController: UIViewController {
    let button = UIButton(type: .close)
    let arrowView = ArrowView(frame: CGRect(origin: .zero, size: CGSize(width: 30, height: 20)))
    let segmented = UISegmentedControl()
    let contentView = UIView()
    let fromPoint: CGPoint
    var height: CGFloat = 280
    
    init(fromPoint: CGPoint) {
        self.fromPoint = fromPoint
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view.backgroundColor = .black.withAlphaComponent(0.2)
    }
    
    override public func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        contentView.frame = CGRect(origin: .zero, size: CGSize(width: 300, height: height))
        contentView.center = CGPoint(x: fromPoint.x, y: fromPoint.y + (height / 2) + 20)
        arrowView.center = CGPoint(x: contentView.center.x, y: contentView.center.y - (height / 2) - 10)
    }
    
    func setHeight(height: CGFloat) {
        UIView.animate(withDuration: 0.2, delay: 0.0) { self.height = height; self.viewDidLayoutSubviews() }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        button.addAction(.init(handler: { _ in self.dismiss(animated: true) }), for: .touchUpInside)
        segmented.addAction(.init(handler: { _ in self.setHeight(height: self.segmented.selectedSegmentIndex == 0 ? 280 : 180) }), for: .valueChanged)
        
        segmented.insertSegment(withTitle: "280pt", at: 0, animated: false)
        segmented.insertSegment(withTitle: "150pt", at: 1, animated: false)
        segmented.selectedSegmentIndex = 0
        
        self.view.addSubview(contentView)
        
        contentView.backgroundColor = .systemBackground
        contentView.layer.cornerRadius = 10
        
        self.contentView.addSubview(button)
        self.contentView.addSubview(segmented)
        self.view.addSubview(arrowView)
        
        button.translatesAutoresizingMaskIntoConstraints = false
        segmented.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            button.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10),
            button.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10)
        ])
        
        NSLayoutConstraint.activate([
            segmented.centerYAnchor.constraint(equalTo: button.centerYAnchor),
            segmented.centerXAnchor.constraint(equalTo: contentView.centerXAnchor)
        ])
    }
}

class ArrowView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = .clear
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        UIColor.white.setFill()
        context.beginPath()
        context.move(to: CGPoint(x: rect.midX, y: rect.minY))
        context.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        context.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        context.closePath()
        context.fillPath()
    }
}
