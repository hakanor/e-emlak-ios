//
//  PriceHistoryCell.swift
//  e-emlak
//
//  Created by Hakan Or on 6.03.2023.
//

import Foundation
import Foundation
import UIKit

class PriceHistoryCell: UITableViewCell {
    
    // MARK: - Subviews
    private lazy var leftLabel: UILabel = {
        let label = UILabel()
        label.textColor = themeColors.dark
        label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        label.contentMode = .scaleToFill
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var rightLabel: UILabel = {
        let label = UILabel()
        label.textColor = themeColors.grey
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.contentMode = .scaleToFill
        label.numberOfLines = 2
        return label
    }()

    
    // MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        backgroundColor = .clear
        [leftLabel, rightLabel] .forEach(contentView.addSubview(_:))
        leftLabel.anchor(left: contentView.leftAnchor, paddingLeft: 5)
        rightLabel.anchor(right: contentView.rightAnchor, paddingRight: 5)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    // MARK: - Configuration
    
    func config(leftSide:String, rightSide:String){
        leftLabel.text = leftSide
        rightLabel.text = rightSide
    }
    
}
