//
//  EditItemView.swift
//  Drawing
//
//  Created by ByungHoon Ann on 2023/11/27.
//

import UIKit

final class EditItemView: UIView {
    var changeColorButton = UIButton()
    var stackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        layout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layout() {
        insertUI()
        basicSetUI()
        anchorUI()
    }
    
    func insertUI() {
        addSubview(stackView)
        stackView.addArrangedSubview(changeColorButton)
    }
    
    func basicSetUI() {
        viewBasicSet()
        stackViewBasicSet()
        changeColorButtonBasicSet()
    }
    
    func anchorUI() {
        stackViewAnchor()
        changeColorButtonAnchor()
    }
    
    func viewBasicSet() {
        backgroundColor = .clear
    }
    
    func stackViewBasicSet() {
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false

    }
    
    func changeColorButtonBasicSet() {
        changeColorButton.setTitle("색변경", for: .normal)
        changeColorButton.setTitleColor(.black, for: .normal)
        changeColorButton.backgroundColor = .white
        changeColorButton.layer.borderWidth = 2
        changeColorButton.layer.borderColor = UIColor.black.cgColor
        changeColorButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func stackViewAnchor() {
        NSLayoutConstraint.activate(
            [
                stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
                stackView.topAnchor.constraint(equalTo: topAnchor),
                stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
            ]
        )
    }
    
    func changeColorButtonAnchor() {
        NSLayoutConstraint.activate(
            [
                changeColorButton.widthAnchor.constraint(equalToConstant: 50),
                changeColorButton.heightAnchor.constraint(equalToConstant: 50)
            ]
        )
    }
    
   
}
