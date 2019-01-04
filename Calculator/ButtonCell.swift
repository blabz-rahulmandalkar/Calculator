import UIKit

class ButtonCell: UICollectionViewCell {

    @IBOutlet weak var containView: UIView!
    
    @IBOutlet weak var textLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.containView.layer.shadowOffset = CGSize(width: 0, height: 0)
        self.containView.layer.shadowOpacity = 0.4
        self.containView.layer.shadowColor = UIColor.black.cgColor
        self.containView.layer.masksToBounds = false
    }
    
    func setSymbol(symbolStr:String){
        self.textLbl.text = symbolStr
    }

}
