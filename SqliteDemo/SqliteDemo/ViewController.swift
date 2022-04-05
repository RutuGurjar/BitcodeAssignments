import UIKit
import SQLite3

struct Employee
{
    var id:Int
    var name:String
    var phoneNumber:Int
    var age:Int
}
class ViewController: UIViewController {

    @IBOutlet weak var txtId: UITextField!
    @IBOutlet weak var txtName: UITextField!
    @IBOutlet weak var txtPhoneNumber: UITextField!
    @IBOutlet weak var txtAge: UITextField!
    
    var employeeArray = [Employee]() 
    let databaseName = "bitcode.sqlite"
    var dbDetailsObject:OpaquePointer?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        openCreateDatabase()
        CreateEmployeeTable()

        
    }
    
    func openCreateDatabase(){
        guard let dbpath = getPathFromDirectory() else{
           print("Document Directory path is missing")
            return
       }
        print("dbpath = \(dbpath)")
        
        //s2
        if sqlite3_open(dbpath, &dbDetailsObject)==SQLITE_OK {
            print("Database is created")
        }
        else
        {
            print("Database is not created")
        }
    }
    //s1
    private func getPathFromDirectory() -> String? {
        
        do{
            let documentDirectoryURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let dbPath = documentDirectoryURL.appendingPathComponent(self.databaseName)
            return dbPath.absoluteString
        }
        catch{
            print(error.localizedDescription)
            return nil
            }
    }
    
    private func CreateEmployeeTable(){
        
        var opaquePointerObjectCreateTable: OpaquePointer?
        
        let createTableQuery = "CREATE TABLE Employee(Id INTEGER PRIMARY KEY, Name TEXT, PhoneNumber TEXT, Age INTEGER);"
        
        // Preapre Query
        if sqlite3_prepare_v2(self.dbDetailsObject, createTableQuery, -1, &opaquePointerObjectCreateTable,
                              nil) == SQLITE_OK {
            print("Query Prepared Create table Successfully")
            
            // Execute Query
            if sqlite3_step(opaquePointerObjectCreateTable) == SQLITE_DONE {
                print("Table Employee created successfully")
            } else {
                print("Table Employee Not created")
            }
        } else {
            print("Query Not Prepared")
        }
        
    }
    
    private func insertEmployeeDataInTable(employee:Employee){
        
        
        var opaquePointerInsertData:OpaquePointer?
        
        let insertQuery = "INSERT INTO Employee VALUES(?,?,?,?)"
        
        if sqlite3_prepare_v2(self.dbDetailsObject, insertQuery, -1, &opaquePointerInsertData, nil) == SQLITE_OK {
            //conversion
            let id = Int32(employee.id)
            let name = (employee.name as NSString).utf8String
            let phoneNumber = Int32(employee.phoneNumber)
            let age = Int32(employee.age)
            
            //binding
            sqlite3_bind_int(opaquePointerInsertData, 1,id)
            sqlite3_bind_text(opaquePointerInsertData, 2, name, -1, nil)
            sqlite3_bind_int(opaquePointerInsertData, 3,phoneNumber)
            sqlite3_bind_int(opaquePointerInsertData, 4,age)
            
            //execute
            if sqlite3_step(opaquePointerInsertData) == SQLITE_DONE{
                print("data inserted")
                let alert = UIAlertController(title: "Add Data", message: "Data Inserted Successfully", preferredStyle: UIAlertController.Style.alert)

                       // add an action (button)
                       alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))

                       // show the alert
                       self.present(alert, animated: true, completion: nil)
            }
            else
            {
                print("data is not inserted")
            }
        }
        else
        {
            print("insert Query not prepared")
        }
    }
   
    @IBAction func btnSave(_ sender: Any) {
        let employeeId:Int = Int(txtId.text ?? "")!
        let employeeName = txtName.text ?? ""
        let employeePhoneNumber = Int(txtPhoneNumber.text ?? "") ?? 0
        let employeeAge = Int(txtAge.text ?? "")!
        let employeeDataObject = Employee(id: employeeId,name: employeeName, phoneNumber: employeePhoneNumber,age: employeeAge)
        insertEmployeeDataInTable(employee: employeeDataObject)
    }
}

