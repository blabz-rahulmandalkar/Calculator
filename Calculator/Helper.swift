import Foundation

class Helper {
    
    static let shared = Helper()
    private init(){}
    
    func isNumber(str:String) -> Bool{
        let range = NSRange(location: 0, length: str.utf16.count)
        let regex = try! NSRegularExpression(pattern: "[0-9]")
        return regex.firstMatch(in: str, options: [], range: range) != nil
    }
    
    func isSymbol(str:String) -> Bool{
        switch str {
        case Constant.ADD,Constant.DIV,Constant.MUL,Constant.SUB:
            return true
        default:
            return false
        }
    }
    
    func isValidDots(str:String) ->Bool{
        let ptn = "[0-9]+.{1}[0-9]+"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", ptn)
        return emailTest.evaluate(with: str)
    }
    
    func trimSymbols(str:String) ->String{
        var newStr = str
        if(isSymbol(str: newStr.first?.description ?? "")){
            newStr.removeFirst()
        }
        if(isSymbol(str: newStr.last?.description ?? "")){
            newStr.removeLast()
        }
        if (newStr.last?.description == "."){
            newStr.removeLast()
        }
        return newStr
    }
    
}
