import UIKit

class AvaliacaoQuestoesTableViewController: UITableViewController {
    
    private let parseManager = ParseManager()
    private var arrayQuestoes = NSArray()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.getQuestoes()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return arrayQuestoes.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cellQuestao", forIndexPath: indexPath) as! QuestaoTableViewCell
        let questao = arrayQuestoes[indexPath.row]
        cell.wideTxt.text = questao.objectForKey("Enunciado") as? String
        
        
        // Configure the cell...
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.performSegueWithIdentifier("goToTabBar", sender: self)
        
    }
    
    /*
    Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    Return false if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return false if you do not want the item to be re-orderable.
    return true
    }
    */
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if(segue.identifier == "goToTabBar"){
            
            let upcoming = segue.destinationViewController as? AvaliacaoQuestaoTabBarController
            let indexPath = self.tableView.indexPathForSelectedRow
            upcoming?.questaoObg = self.arrayQuestoes[(indexPath?.row)!] as! PFObject
            
            let PAVC = PerguntasAvaliacaoViewController()
            PAVC.strForTextView = (upcoming?.questaoObg.objectForKey("Enunciado"))! as! String

            //            let cell = self.tableView.cellForRowAtIndexPath(indexPath!)! as UITableViewCell
            
            
            //            let respostaUsuario = singleton.respostasUsuario[(indexPath?.row)!] as! String
            //
            //            upcoming!.strResposta  = (singleton.questoes[(indexPath?.row)!].objectForKey("AlternativaA") as? String)!
            //            upcoming!.strEnunciado = (singleton.questoes[(indexPath?.row)!].objectForKey("Enunciado") as? String)!
            //            upcoming?.strUserResposta = respostaUsuario
            
            
            
            
        }
        
        
    }
    
    
    func getQuestoes(){
        self.arrayQuestoes = self.parseManager.getAllProvas()
    }
    
}
