import UIKit

class AddUpdateStudentDataViewController: UIViewController {

    //MARK:Outlets
    @IBOutlet var txtName: UITextField!
    @IBOutlet var txtCity: UITextField!
    @IBOutlet var txtContactNo: UITextField!
    
    //MARK:Variable Declaration
    var studName:String?
    var studCity:String?
    var studContactNo:String?
    var dataIndex:Int?
    
    weak var delegate:StudentDetailsProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.txtName.text = studName ?? ""
        self.txtCity.text = studCity ?? ""
        self.txtContactNo.text = studContactNo ?? ""
    }
    
    //MARK: Button ADD AND UPDATE Action Event
    @IBAction func btnAddUpdate(_ sender: Any) {
        
        let sName = txtName.text
        let sCity = txtCity.text
        let sContactNo = txtContactNo.text 
        
        if let updateIndex = dataIndex // For Update
        {
            if let delegate = delegate {
                delegate.StudentData(studentName: sName, studentCity: sCity, studentContactNo: sContactNo, index: updateIndex)
                self.navigationController?.popViewController(animated: true)
            }
            else
            {
                print("No delegate provided")
            }
        }
        else
        {
            if let delegate = self.delegate // For Add
            {
                delegate.StudentData(studentName: sName, studentCity: sCity, studentContactNo: sContactNo, index: nil)
                self.navigationController?.popViewController(animated: true)
            }
            else
            {
                print("No delegate provided")
            }
        }
    }
    
}
