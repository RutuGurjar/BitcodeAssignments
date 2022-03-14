import UIKit

class StudentListViewController: UIViewController,StudentDetailsProtocol,UITableViewDataSource,UITableViewDelegate {
    
    //MARK:Outlets
    @IBOutlet weak var studentListTableView: UITableView!
    
    var studentDetailsArray = [Student]()
    
   override func viewDidLoad() {
        super.viewDidLoad()
       
       self.title = "Student List"
       
       self.studentListTableView.dataSource = self
       self.studentListTableView.delegate = self
       
       let studentDetailsTableCellNib = UINib(nibName: "StudentListTableViewCell", bundle: Bundle.main)
       self.studentListTableView.register(studentDetailsTableCellNib, forCellReuseIdentifier: "StudentListTableViewCell")
       
       //MARK: Bar Button Logic
        let barButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addUpdateVC))
        self.navigationItem.rightBarButtonItem = barButton
        barButton.tintColor = UIColor.yellow
    }
    @objc func addUpdateVC()
    {
        navigateVC2()
    }
    func navigateVC2()
    {
        if let vc2 = self.storyboard?.instantiateViewController(withIdentifier: "AddUpdateStudentDataViewController") as? AddUpdateStudentDataViewController
        {
            vc2.delegate = self
            self.navigationController?.pushViewController(vc2, animated: true)
        }
        else
        {
           print("No Data")
        }
            
    }
    //MARK: Protocol Method
    func StudentData(studentName: String?, studentCity: String?, studentContactNo: String? , index:Int?) {
        
        if let updateIndex = index
        {
            var studentIndexData = studentDetailsArray[updateIndex]
            studentIndexData.name = studentName ?? ""
            studentIndexData.city = studentCity ?? ""
            studentIndexData.contactNo = studentContactNo ?? ""
            studentDetailsArray[updateIndex] = studentIndexData
        }
        else
        {
            let students = Student(name: studentName, city: studentCity, contactNo: studentContactNo)
            studentDetailsArray.append(students)
        }
        studentListTableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        studentDetailsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       if let studentDetailsCell = studentListTableView.dequeueReusableCell(withIdentifier: "StudentListTableViewCell") as? StudentListTableViewCell
        {
           print(indexPath.row)
           print(studentDetailsArray[indexPath.row].name ?? "")
           studentDetailsCell.lblName.text = studentDetailsArray[indexPath.row].name ?? ""
           studentDetailsCell.lblCity.text = studentDetailsArray[indexPath.row].city ?? ""
           studentDetailsCell.lblContactNo.text = studentDetailsArray[indexPath.row].contactNo ?? ""
           return studentDetailsCell
        }
        else
        {
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let vc2 = self.storyboard?.instantiateViewController(withIdentifier: "AddUpdateStudentDataViewController") as? AddUpdateStudentDataViewController
        {
            vc2.delegate = self
            vc2.studName = studentDetailsArray[indexPath.row].name
            vc2.studCity = studentDetailsArray[indexPath.row].city
            vc2.studContactNo = studentDetailsArray[indexPath.row].contactNo
            vc2.dataIndex = indexPath.row
            self.navigationController?.pushViewController(vc2, animated: true)
        }
        else
        {
            print("please select Cell")
        }
    }
}

