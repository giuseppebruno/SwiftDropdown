/// SwiftDropdown
/// Copyright © 2022 Giuseppe Bruno (https://gbrunodev.it)
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
import UIKit

@objc public protocol SwiftDropdownDelegate: UITextFieldDelegate {
    @objc optional func dropdownItemSelected(identifier: String?, index: Int, item: String) -> Void
}

public enum ArrowPosition {
    case left
    case right
}

public class SwiftDropdown: UIView, DropdownViewControllerDelegate {
    
    
    private let dropdown = Dropdown()
    private var dropdownViewController = DropdownViewController()
    private var currentSelectedIndex: Int?
    private var currentSelectedItem: String?
    
    public var delegate: SwiftDropdownDelegate?
    /// Dropdown identifier
    @IBInspectable public var identifier: String?
    /// Dropdown height. By default will be calculated automatically.
    public var dropdownHeight: CGFloat?
    /// Dropdown box background color.
    public var boxBackgroundColor: UIColor = UIColor(red: 227/255, green: 227/255, blue: 227/255, alpha: 1)
    /// Dropdown box text
    public var placeholderText: String? = "Select..."
    /// Dropdown box text font. Default: System font
    public var placeholderFont: UIFont? = UIFont.systemFont(ofSize: 16)
    /// Dropdown box text color. Default: black
    public var placeholderColor: UIColor? = .black
    /// Items array
    public var options: [String] = []
    /// Arrow image
    public var arrowImage: UIImage? = UIImage(named: "arrow")
    /// Arrow position. Default: right
    public var arrowPosition: ArrowPosition = .right
    /// Box and dropdown corner radius. Default: 8
    public var cornerRadius: CGFloat = 8
    /// Box and dropdown border width. Default: 1
    public var borderWidth: CGFloat = 1
    /// Box and dropdown border color. Default: lightGray
    public var borderColor: CGColor? = UIColor.lightGray.cgColor
    /// Disable arrow animation. Default: true
    public var disableArrowAnimation: Bool = true
    /// Dropdown items row height. Default: 44
    public var itemsRowHeight: CGFloat = 44
    /// Dropdown items text font. Default: System font
    public var itemsFont: UIFont? = UIFont.systemFont(ofSize: 16)
    /// Dropdown items text color. Default: black
    public var itemsTextColor: UIColor? = .black
    /// Disable tap outside the dropdown to dismiss itself. Default: false
    public var disableTapToDismiss: Bool = false
    /// Space between the box and the dropdown. Default: 8
    public var dropdownExtraSpace: CGFloat = 8
    /// Dropdown separator style. Default: singleLine
    public var dropdownSeparatorStyle: UITableViewCell.SeparatorStyle = .singleLine
    /// Dropdown items background color. Default: white
    public var itemsBackgroundColor: UIColor? = .white
    /// Show checkmark for selected item. Default: true
    public var showSelectedItemCheckmark: Bool = true
    /// Selected item checkmark color. Default: system blue
    public var checkmarkColor: UIColor? = .systemBlue
    /// Highlight selected item. Default: false
    public var highlightSelectedItem: Bool = false
    /// Selected item background color. Default: system blue
    public var selectedItemBackgroundColor: UIColor = .systemBlue
    /// Selected item text color. Default: white
    public var selectedItemTextColor: UIColor = .white
    /// Current selected index
    public var selectedIndex: Int? {
        get {
            return currentSelectedIndex
        }
        set {
            currentSelectedIndex = newValue
            if let index = selectedIndex, options.indices.contains(index) {
                dropdown.text = options[index]
            } else {
                dropdown.text = placeholderText
            }
        }
    }
    /// Current selected item
    public var selectedItem: String? {
        return currentSelectedItem
    }
    ///
    lazy var convertedPoint: CGFloat? = (self.superview?.convert(self.center, to: self.getParentViewController?.view).y ?? 0) + self.frame.height
    public var dropdownStartPoint: CGFloat? {
        get {
            return convertedPoint
        }
        set {
            convertedPoint = newValue
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    
    private func setupView() {
        dropdown.delegate = delegate
        addSubview(dropdown)
        dropdown.translatesAutoresizingMaskIntoConstraints = false
        dropdown.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0).isActive = true
        dropdown.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        dropdown.rightAnchor.constraint(equalTo: rightAnchor, constant: 0).isActive = true
        dropdown.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0).isActive = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(showDropdown))
        addGestureRecognizer(tap)
    }
    
    public override func layoutSubviews() {
        dropdown.backgroundColor = boxBackgroundColor
        dropdown.font = placeholderFont
        if let selectedIndex = selectedIndex {
            dropdown.text = options[selectedIndex]
        } else {
            dropdown.text = placeholderText
        }
        dropdown.textColor = placeholderColor
        dropdown.arrowImage = arrowImage
        dropdown.arrowPosition = arrowPosition
        dropdown.layer.cornerRadius = cornerRadius
        dropdown.layer.borderWidth = borderWidth
        dropdown.layer.borderColor = borderColor
        dropdown.disableArrowAnimation = disableArrowAnimation
    }
    
    @objc private func showDropdown() {
        
        dropdown.setArrow(rotateDown: true)
        
        dropdownViewController = DropdownViewController(width: dropdown.frame.width,
                                                        height: dropdownHeight,
                                                        startPosition: dropdownStartPoint ?? frame.maxY,
                                                        options: options,
                                                        cornerRadius: cornerRadius,
                                                        borderWidth: borderWidth,
                                                        borderColor: borderColor,
                                                        itemsRowHeight: itemsRowHeight,
                                                        itemsFont: itemsFont,
                                                        itemsTextColor: itemsTextColor,
                                                        disableTapToDismiss: disableTapToDismiss,
                                                        dropdownExtraSpace: dropdownExtraSpace,
                                                        itemsBackgroundColor: itemsBackgroundColor,
                                                        showSelectedItemCheckmark: showSelectedItemCheckmark,
                                                        selectedIndex: selectedIndex,
                                                        checkmarkColor: checkmarkColor,
                                                        highlightSelectedItem: highlightSelectedItem,
                                                        selectedItemBackgroundColor: selectedItemBackgroundColor,
                                                        selectedItemTextColor: selectedItemTextColor,
                                                        separatorStyle: dropdownSeparatorStyle)
        dropdownViewController.delegate = self
        
        UIApplication.shared.getVisibleViewController?.present(self.dropdownViewController, animated: true)
        
    }
    
    // MARK: DropdownViewController Delegate
    
    fileprivate func dropdownItemSelected(_ index: Int, _ item: String) {
        dropdown.text = item
        currentSelectedIndex = index
        currentSelectedItem = item
        delegate?.dropdownItemSelected?(identifier: identifier, index: index, item: item)
    }
    
    fileprivate func dropdownClosed() {
        dropdown.setArrow(rotateDown: false)
    }
    
    private class Dropdown: UITextField {

        private var arrow = UIImageView()
        var arrowImage: UIImage?
        var arrowPosition: ArrowPosition = .right
        var disableArrowAnimation: Bool = true
        
        override func draw(_ rect: CGRect) {
            
            isEnabled = false // MARK: Important
            
            clipsToBounds = true
            
            leftView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 40))
            leftViewMode = .always
            
            rightView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: 40))
            rightViewMode = .always
            
            if let arrowImage = arrowImage {
                let arrowView = UIView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
                arrow = UIImageView(image: arrowImage)
                arrowView.addSubview(arrow)
                arrow.translatesAutoresizingMaskIntoConstraints = false
                
                switch arrowPosition {
                case .left:
                    arrow.widthAnchor.constraint(equalToConstant: 24).isActive = true
                    arrow.heightAnchor.constraint(equalToConstant: 24).isActive = true
                    arrow.leadingAnchor.constraint(equalTo: arrowView.leadingAnchor, constant: 16).isActive = true
                    arrow.topAnchor.constraint(equalTo: arrowView.topAnchor, constant: 0).isActive = true
                    arrow.rightAnchor.constraint(equalTo: arrowView.rightAnchor, constant: -8).isActive = true
                    arrow.bottomAnchor.constraint(equalTo: arrowView.bottomAnchor, constant: 0).isActive = true
                    
                    leftView = arrowView
                    leftViewMode = .always
                case .right:
                    arrow.widthAnchor.constraint(equalToConstant: 24).isActive = true
                    arrow.heightAnchor.constraint(equalToConstant: 24).isActive = true
                    arrow.leadingAnchor.constraint(equalTo: arrowView.leadingAnchor, constant: 0).isActive = true
                    arrow.topAnchor.constraint(equalTo: arrowView.topAnchor, constant: 0).isActive = true
                    arrow.rightAnchor.constraint(equalTo: arrowView.rightAnchor, constant: -16).isActive = true
                    arrow.bottomAnchor.constraint(equalTo: arrowView.bottomAnchor, constant: 0).isActive = true
                    
                    rightView = arrowView
                    rightViewMode = .always
                }
            }
            
        }
        
        func setArrow(rotateDown: Bool) {
            
            if !disableArrowAnimation {
                if rotateDown {
                    UIView.animate(withDuration: 0.3, delay: 0) {
                        self.arrow.transform = CGAffineTransform(rotationAngle: CGFloat.pi * 180 / 180.0)
                    }
                } else {
                    UIView.animate(withDuration: 0.3, delay: 0) {
                        self.arrow.transform = CGAffineTransform(rotationAngle: CGFloat.pi * -360 / 180.0)
                    }
                }
            }
            
        }
        
    }
    
    private class DropDownCell: UITableViewCell {
        
        var itemsRowHeight: CGFloat = 44
        var itemsFont: UIFont? = UIFont.systemFont(ofSize: 16)
        var itemsTextColor: UIColor? = .black
        var titleLbl = UILabel()
        
        override func draw(_ rect: CGRect) {
            titleLbl.numberOfLines = 0
            titleLbl.font = itemsFont
            titleLbl.textColor = itemsTextColor
            addSubview(titleLbl)
            titleLbl.translatesAutoresizingMaskIntoConstraints = false
            titleLbl.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
            titleLbl.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
            titleLbl.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
            titleLbl.heightAnchor.constraint(equalToConstant: itemsRowHeight-16).isActive = true
        }
    }

    private class DropdownViewController: UIViewController, UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource {
        
        private var width: CGFloat = 100
        private var height: CGFloat = 100
        private let bgView = UIView()
        private var options: [String] = []
        private var itemsRowHeight: CGFloat = 44
        private var itemsFont: UIFont? = UIFont.systemFont(ofSize: 16)
        private var itemsTextColor: UIColor? = .black
        private var itemsBackgroundColor: UIColor? = .white
        private var showSelectedItemCheckmark: Bool = false
        private var selectedIndex: Int?
        private var checkmarkColor: UIColor? = .systemBlue
        private var highlightSelectedItem: Bool = false
        private var selectedItemBackgroundColor: UIColor = .systemBlue
        private var selectedItemTextColor: UIColor = .white
        private var separatorStyle: UITableViewCell.SeparatorStyle = .singleLine
        
        var delegate: DropdownViewControllerDelegate?
        
        init() {
            super.init(nibName: nil, bundle: nil)
        }
        
        init(width: CGFloat,
             height: CGFloat? = nil,
             startPosition: CGFloat,
             options: [String],
             cornerRadius: CGFloat,
             borderWidth: CGFloat,
             borderColor: CGColor?,
             itemsRowHeight: CGFloat,
             itemsFont: UIFont?,
             itemsTextColor: UIColor?,
             disableTapToDismiss: Bool,
             dropdownExtraSpace: CGFloat,
             itemsBackgroundColor: UIColor?,
             showSelectedItemCheckmark: Bool,
             selectedIndex: Int?,
             checkmarkColor: UIColor?,
             highlightSelectedItem: Bool,
             selectedItemBackgroundColor: UIColor,
             selectedItemTextColor: UIColor,
             separatorStyle: UITableViewCell.SeparatorStyle) {
            
            self.width = width
            self.height = height ?? min(CGFloat(options.count)*itemsRowHeight, 300)
            self.options = options
            self.itemsRowHeight = itemsRowHeight
            self.itemsFont = itemsFont
            self.itemsTextColor = itemsTextColor
            self.itemsBackgroundColor = itemsBackgroundColor
            self.showSelectedItemCheckmark = showSelectedItemCheckmark
            self.selectedIndex = selectedIndex
            self.checkmarkColor = checkmarkColor
            self.highlightSelectedItem = highlightSelectedItem
            self.selectedItemBackgroundColor = selectedItemBackgroundColor
            self.selectedItemTextColor = selectedItemTextColor
            self.separatorStyle = separatorStyle
            
            super.init(nibName: nil, bundle: nil)
            view.backgroundColor = .clear
            modalPresentationStyle = .overCurrentContext
            modalTransitionStyle = .crossDissolve
            
            bgView.backgroundColor = .white
            bgView.layer.cornerRadius = cornerRadius
            bgView.layer.borderWidth = borderWidth
            bgView.layer.borderColor = borderColor
            bgView.clipsToBounds = true
            view.addSubview(bgView)
            
            bgView.translatesAutoresizingMaskIntoConstraints = false
            bgView.topAnchor.constraint(equalTo: view.topAnchor, constant: startPosition + dropdownExtraSpace).isActive = true
            bgView.widthAnchor.constraint(equalToConstant: width).isActive = true
            bgView.heightAnchor.constraint(equalToConstant: self.height).isActive = true
            bgView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0).isActive = true
            
            let tableView = UITableView()
            tableView.delegate = self
            tableView.dataSource = self
            tableView.register(DropDownCell.self, forCellReuseIdentifier: "cell")
            tableView.bounces = false
            tableView.separatorStyle = separatorStyle
            bgView.addSubview(tableView)
            
            tableView.translatesAutoresizingMaskIntoConstraints = false
            tableView.leadingAnchor.constraint(equalTo: bgView.leadingAnchor, constant: 0).isActive = true
            tableView.topAnchor.constraint(equalTo: bgView.topAnchor, constant: 0).isActive = true
            tableView.rightAnchor.constraint(equalTo: bgView.rightAnchor, constant: 0).isActive = true
            tableView.bottomAnchor.constraint(equalTo: bgView.bottomAnchor, constant: 0).isActive = true
            
            if !disableTapToDismiss {
                let tap = UITapGestureRecognizer(target: self, action: #selector(dismissViewController))
                tap.delegate = self
                view.addGestureRecognizer(tap)
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.01, execute: {
                tableView.reloadData()
            })
        }
        
        required init?(coder: NSCoder) {
            super.init(coder: coder)
        }
        
        @objc func dismissViewController() {
            delegate?.dropdownClosed()
            dismiss(animated: true)
        }
        
        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return itemsRowHeight
        }
        
        func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return options.count
        }
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! DropDownCell
            
            cell.backgroundColor = itemsBackgroundColor
            cell.tintColor = checkmarkColor
            
            cell.itemsRowHeight = itemsRowHeight
            cell.titleLbl.text = options[indexPath.row]
            cell.itemsFont = itemsFont
            cell.itemsTextColor = itemsTextColor
            
            if highlightSelectedItem && selectedIndex == indexPath.row {
                
                cell.backgroundColor = selectedItemBackgroundColor
                cell.itemsTextColor = selectedItemTextColor
                
            } else if showSelectedItemCheckmark && selectedIndex == indexPath.row {
                
                cell.accessoryType = .checkmark
                
            } else {
                cell.accessoryType = .none
            }
            
            return cell
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
            delegate?.dropdownItemSelected(indexPath.row, options[indexPath.row])
            dismissViewController()
        }
        
        func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
            return !self.bgView.bounds.contains(touch.location(in: self.bgView))
        }
        
    }
    
}

private protocol DropdownViewControllerDelegate {
    func dropdownItemSelected(_ index: Int, _ item: String) -> Void
    func dropdownClosed() -> Void
}

fileprivate extension UIApplication {

    var getVisibleViewController: UIViewController? {

        if #available(iOS 13.0, *) {
            
            guard let rootViewController = connectedScenes.flatMap({($0 as? UIWindowScene)?.windows ?? []}).first(where: {$0.isKeyWindow})?.rootViewController else {
                return nil
            }
            
            return getVisibleViewController(rootViewController)
            
        } else {
            
            guard let rootViewController = keyWindow?.rootViewController else {
                return nil
            }
            
            return getVisibleViewController(rootViewController)
        }
        
    }

    private func getVisibleViewController(_ rootViewController: UIViewController) -> UIViewController? {

        if let presentedViewController = rootViewController.presentedViewController {
            return getVisibleViewController(presentedViewController)
        }

        if let navigationController = rootViewController as? UINavigationController {
            return navigationController.visibleViewController
        }

        if let tabBarController = rootViewController as? UITabBarController {
            return tabBarController.selectedViewController
        }

        return rootViewController
    }
}

fileprivate extension UIView {
    var getParentViewController: UIViewController? {
        // Starts from next (As we know self is not a UIViewController).
        var parentResponder: UIResponder? = self.next
        while parentResponder != nil {
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
            parentResponder = parentResponder?.next
        }
        return nil
    }
}
