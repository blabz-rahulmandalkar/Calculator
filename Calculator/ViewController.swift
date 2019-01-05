
import UIKit

class ViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    //MARK: IBOutlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var outputLbl: UILabel!
    
    //MARK:Constants & Variables
    let reuseIdentifier = "ButtonCell"
    let symbols = [Constant.SQRT,"AC","",Constant.DIV,"7","8","9",Constant.MUL,"4","5","6",Constant.SUB,"1","2","3",Constant.ADD
        ,"C","0","",Constant.EQL,"",""]
    var historyList:[Double] = []
    var prevNumber:Double = 0
    var currentValue:String = ""
    var prevSymbol:String = ""
    var numberOnScreen:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.outputLbl.text = String(describing: numberOnScreen)
        self.collectionView.register(UINib(nibName: "ButtonCell", bundle: nil), forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
    }
    
    //MARK:Collection Data Source Methods
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return symbols.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? ButtonCell
        cell?.setSymbol(symbolStr: symbols[indexPath.row])
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width:CGFloat = self.collectionView.frame.size.width/4
        let height:CGFloat = self.collectionView.frame.size.height/6
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.handleInput(index: indexPath.row)
        guard let cell = collectionView.cellForItem(at: indexPath) as? ButtonCell else{
            return
        }
        UIView.animate(withDuration: 0.2, animations: {
            cell.containView.layer.shadowColor = UIColor.blue.cgColor
            cell.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
        }, completion: { _ in
            cell.transform = .identity
            cell.containView.layer.shadowColor = UIColor.black.cgColor
        })
    }
    
    //MARK: Custom methods
    func handleInput(index:Int){
        switch index {
        case 0:
            guard var value = self.outputLbl.text else { return}
            value = Helper.shared.trimSymbols(str: value)
            let exp = "sqrt(\(value))"
            self.calculateExpression(expression:exp,callback: { (result) in
                self.outputLbl.text = result
            })
        case 1:
            self.clearScreen()
        case 19:
            guard var value = self.outputLbl.text else { return}
            value = Helper.shared.trimSymbols(str: value)
            self.calculateExpression(expression:value,callback: { (result) in
                self.outputLbl.text = result
            })
        case 16:
            self.removeLast()
        default:
            print(symbols[index])
            guard let value = self.outputLbl.text else { return}
                switch symbols[index] {
                case Constant.ADD,Constant.MUL,Constant.DIV,Constant.SUB:
                    if(Helper.shared.isSymbol(str: self.prevSymbol)){
                        self.outputLbl.text?.removeLast()
                    }
                    self.outputLbl.text = self.outputLbl.text?.appending(symbols[index])
                    
                    break
                default:
                    if(Helper.shared.isNumber(str: symbols[index])){
                        guard let intNum = Int(self.symbols[index]) else { return}
                        if(value == "0"){
                            self.outputLbl.text = String(describing: intNum)
                        }else{
                            self.outputLbl.text = self.outputLbl.text?.appending(String(describing: intNum))
                        }
                    }
                    break
                }
                self.prevSymbol = self.symbols[index]
           
        }
    }
    
    func calculateExpression(expression:String?,callback:(_ result:String)->Void){
        if let value = expression {
            guard value != "0" else { return }
            let mathExpression = NSExpression(format: value)
            guard let mathValue = mathExpression.toFloatingPoint().expressionValue(with: nil, context: nil) as? Double else {
                return
            }
            callback(String(describing: mathValue))
        }
    }
    
    func removeLast(){
        guard let value = self.outputLbl?.text else { return }
        if(value != "0"){
            self.outputLbl.text?.removeLast()
            if(self.outputLbl.text == nil || self.outputLbl.text?.count == 0){
                self.outputLbl.text = String(describing: numberOnScreen)
            }
        }
    }
    
    func clearScreen(){
        self.outputLbl.text = String(describing: numberOnScreen)
        self.prevSymbol = ""
    }
    
    override func viewDidLayoutSubviews() {
        self.view.layoutIfNeeded()
        self.collectionView.layoutIfNeeded()
        self.collectionView.reloadData()
    }
}

