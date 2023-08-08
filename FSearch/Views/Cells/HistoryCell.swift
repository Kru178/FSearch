//
//  HistoryCell.swift
//  FSearch
//
//  Created by Sergei Krupenikov on 03.08.2023.
//

import UIKit

final class HistoryCell: UITableViewCell {
    static let reuseID = Constants.Cells.HistoryCell.reuseID
    private let searchWordLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.textColor = .black
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        label.setContentCompressionResistancePriority(.required, for: .horizontal)
        label.textAlignment = .right
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: UITableViewCell.CellStyle.value2, reuseIdentifier: reuseIdentifier)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configure() {
        accessoryType = .disclosureIndicator
        addSubviews(searchWordLabel, dateLabel)
        
        let padding: CGFloat = 24
        NSLayoutConstraint.activate([
            searchWordLabel.topAnchor.constraint(equalTo: self.topAnchor),
            searchWordLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            searchWordLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: padding),
            
            dateLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            dateLabel.leadingAnchor.constraint(equalTo: searchWordLabel.trailingAnchor, constant: 10),
            dateLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -2 * padding)
        ])
    }
    
    func set(history: HistoryEntry) {
        searchWordLabel.text = history.text
        dateLabel.text = history.date.dateToString()
    }
}
