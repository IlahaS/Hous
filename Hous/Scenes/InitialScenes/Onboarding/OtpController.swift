import UIKit
import SnapKit

class OtpController: UIViewController {
    
    var mobileNumber: String?
    var enteredOTP = ""
    
    let descLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .gray
        label.numberOfLines = 0
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.backgroundColor = .red
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }()
    
    let containerView: UIView = {
        let view = UIView()
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor.gray.cgColor
        view.layer.cornerRadius = 10
        view.backgroundColor = .lightGray
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupUI()
        
        if let mobileNumber = mobileNumber {
            let attributedString = NSMutableAttributedString(string: "Kod \(mobileNumber) nömrəsinə göndəriləcək.")
            let range = (attributedString.string as NSString).range(of: mobileNumber)
            attributedString.addAttribute(.foregroundColor, value: UIColor.black, range: range)
            
            descLabel.attributedText = attributedString
        }
        
    }
    
    private lazy var nextButton: ReusableButton = {
        let button = ReusableButton(title: "Təsdiqlə", color: .mainBlueColor) {
            self.goToAccountScreen()
        }
        return button
    }()
    
    @objc func goToAccountScreen(){
        let accountController = SelectAccountController()
        navigationController?.pushViewController(accountController, animated: true)
    }
    
    func setupUI() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.title = "Birdəfəlik kodu daxil edin."
        navigationController?.navigationBar.largeTitleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.black,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24, weight: .bold)
        ]
        
        view.addSubview(descLabel)
        descLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(8)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
        }
        
        view.addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.equalTo(descLabel.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.height.equalTo(56)
        }
        
        containerView.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8))
        }
        
        stackView.distribution = .fillEqually
        
        for _ in 1...4 {
            let dotContainer = createDotContainer()
            stackView.addArrangedSubview(dotContainer)
        }
        
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.top.equalTo(containerView.snp.bottom).offset(24)
        }
    }
    
    func createDotContainer() -> UIView {
        let dotContainer = UIView()
        dotContainer.backgroundColor = .orange
        
        let dotLabel: UILabel = {
            let label = UILabel()
            label.text = "●"
            label.font = UIFont.systemFont(ofSize: 20)
            label.textColor = .grayColor
            return label
        }()
        
        let textField: UITextField = {
            let textField = UITextField()
            textField.backgroundColor = .systemPink
            //textField.isSecureTextEntry = true
            textField.textAlignment = .center
            textField.font = UIFont.systemFont(ofSize: 20, weight: .bold)
            textField.textColor = .black
            //textField.placeholder = "●"
            textField.keyboardType = .numberPad
            textField.frame = .init(x: 0, y: 0, width: view.frame.width, height: 32)
            textField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
            //            textField.delegate = self
            return textField
        }()
        
        dotContainer.addSubview(dotLabel)
        dotLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        dotContainer.addSubview(textField)
        textField.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        return dotContainer
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if let dotLabel = (textField.superview?.subviews.compactMap { $0 as? UILabel })?.first {
            dotLabel.isHidden = textField.text?.isEmpty ?? true
            dotLabel.text = textField.text
        }
        
        if let text = textField.text, !text.isEmpty {
            textField.becomeFirstResponder()
        }
        
//        if let nextTextField = (stackView.arrangedSubviews.compactMap { ($0).subviews.compactMap { ($0 as? UITextField) } }.joined()).first(where: { $0 != textField }) {
//            if let text = textField.text, !text.isEmpty {
//                nextTextField.becomeFirstResponder()
//            }
//        } else {
//            textField.resignFirstResponder()
//        }
    }
    
    
    
    
    //
    //extension OtpController: UITextFieldDelegate {
    //    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    //        guard textField.text != nil else { return false }
    //
    //        if string.isEmpty {
    //            textField.text = ""
    //        } else {
    //            textField.text = string
    //
    //            if let stackView./*arrangedSubviews*/ as
    //
    //            if let dotLabel = (textField.superview?.subviews.compactMap { $0 as? UILabel })?.first {
    ////                dotLabel.text = string
    //            }
    //
    //            if let nextTextField = (stackView.arrangedSubviews.compactMap { ($0).subviews.compactMap { ($0 as? UITextField) } }.joined()).first(where: { $0 != textField }) {
    //                nextTextField.becomeFirstResponder()
    //            } else {
    //                textField.resignFirstResponder()
    //            }
    //        }
    //
    //        enteredOTP = stackView.arrangedSubviews.compactMap { ($0).subviews.compactMap { ($0 as? UITextField)?.text }.joined() }.joined()
    //
    //        return false
    //    }
    //}
}

extension OtpController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let text = textField.text {
            let leftPart = text.substring(to: <#T##String.Index#>)
        }
    }
}
