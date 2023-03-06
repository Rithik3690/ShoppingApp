//
//  ProfileCell.swift
//  

import UIKit

class ProfileCell: UITableViewCell {

    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    
    static let identifier = "ProfileCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    static func nib() -> UINib {
        return UINib(nibName: ProfileCell.identifier, bundle: nil)
    }
    
    func configure(with viewModel: ProfileCellViewModel) {
        containerView.backgroundColor = App.Theme.current.package.accentColor.withAlphaComponent(0.1)
        detailLabel.attributedText = createText(firstTextTitle: "\(viewModel.title ?? ""):  ", secondTextTitle: viewModel.body ?? "")
        
    }
    
    private func createText(firstTextTitle: String, firstTextFont: UIFont = .boldSystemFont(ofSize: 16), firstTextColor: UIColor = App.Theme.current.package.primaryTextColor.withAlphaComponent(0.8), secondTextTitle: String, secondTextFont: UIFont = .systemFont(ofSize: 14), secondTextColor: UIColor = App.Theme.current.package.primaryTextColor.withAlphaComponent(0.8)) -> NSMutableAttributedString {
        let attrString: NSMutableAttributedString = NSMutableAttributedString(string: firstTextTitle,attributes: [NSAttributedString.Key.font : firstTextFont, NSAttributedString.Key.foregroundColor : firstTextColor])
        attrString.append(NSMutableAttributedString(string: secondTextTitle, attributes: [NSAttributedString.Key.font : secondTextFont, NSAttributedString.Key.foregroundColor : secondTextColor]))
        return attrString
    }
}
