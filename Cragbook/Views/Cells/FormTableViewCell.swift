//
//  FormTableViewCell.swift
//  Cragbook
//
//  Created by Ben Williams on 21/11/2020.
//  Copyright © 2020 Ben Williams. All rights reserved.
//

import UIKit

// FormTableViewCellDelegate Protocol
protocol FormTableViewCellDelegate: AnyObject {
    func formTableViewCell(_ cell: FormTableViewCell, didUpdateTextField updatedModel: EditProfileFormModel)
}

class FormTableViewCell: UITableViewCell {
    
    // Reuse identifier so that this can be referenced from elsewhere and doesn't have to be hard-typed
    static let identifier = "FormTableViewCell"
    
    // Model for cell
    private var model: EditProfileFormModel?
    
    // Public delegate to be used by the view controller that is being set as the cell's delegate
    public var delegate: FormTableViewCellDelegate?
    
    // Create label with for left side of cell
    private let formLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 1
        return label
    }()
    
    // Create text field for right side of cell
    private let formTextField: UITextField = {
        let field = UITextField()
        field.returnKeyType = .done
        return field
    }()
    
    // Add above elements when new instance is initialised and set the delegate to the controller that has initialised it, as well as making it so that the cell can't be selected
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        clipsToBounds = true
        contentView.addSubview(formLabel)
        contentView.addSubview(formTextField)
        formTextField.delegate = self
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // The tableView can configure each cell with this method by passing in the model at the current index path
    public func configure(with model: EditProfileFormModel) {
        self.model = model
        formLabel.text = model.label
        formTextField.placeholder = model.placeholder
        formTextField.text = model.value
    }
    
    // Ensures that when the cells are being reused, they don't accidentally keep the values from the previous cell
    override func prepareForReuse() {
        formLabel.text = nil
        formTextField.placeholder = nil
        formTextField.text = nil
    }
    
    // Assign frames to label and text field
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // Assign frames
        formLabel.frame = CGRect(x: 5,
                                 y: 0,
                                 width: contentView.width/3,
                                 height: contentView.height)
        formTextField.frame = CGRect(x: formLabel.right + 5,
                                     y: 0,
                                     width: contentView.width - formLabel.width - 10,
                                     height: contentView.height)
        
        
    }
    
}

// MARK:- Text Field Delegate Methods

extension FormTableViewCell: UITextFieldDelegate {
    
    // What happens when return on the keyboard is tapped
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Add textfield text to the value property of the model
        model?.value = textField.text
        
        // Assign the entire model to a new constant called model, which is passed into the function below
        guard let model = model else {
            return true
        }
        
        // The delegate view controller (EditProfileViewController) stores the passed in model for the cell
        delegate?.formTableViewCell(self, didUpdateTextField: model)
        
        // Close keyboard from screen
        textField.resignFirstResponder()
        return true
    }
}
