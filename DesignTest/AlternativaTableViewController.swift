
import UIKit

class AlternativaTableViewController: UITableViewController  {
    
    private let questoesManager = QuestoesManager.singleton
    private var arrayAlternativas = NSMutableArray()
    private var arrayCell = NSMutableArray()
    private var idQuestao = String()
    var selected: PerguntasTableViewCell?
    
    var questao: PFObject?
    private var resposta: String?
    private var currentCell = PerguntasTableViewCell()
    
    
    //        - (void)tableView:(NSTableView *)tableView sortDescriptorsDidChange:(NSArray *)oldDescriptors
    //    {
    //    [peopleArray sortUsingDescriptors: [tableView sortDescriptors]];
    //    [tableView reloadData];
    //    }
    //
    
    
    
    override  func viewDidLoad() {
        super.viewDidLoad()
        self.automaticallyAdjustsScrollViewInsets = false;
        self.carregaQuestao()
        
        
        self.tableView.tableHeaderView = nil
        self.tableView.contentInset = UIEdgeInsetsMake(-36, 0, 0, 0);
        
        self.automaticallyAdjustsScrollViewInsets = false
        self.configNavBarHidingCells()
        self.configTabbarHidingCells()
    }
    
    //    MARK: Config
    func configNavBarHidingCells(){
        let top = UIView(frame: CGRectMake(0, 0, 1, 60))
        top.backgroundColor = UIColor.clearColor()
        self.tableView.tableHeaderView = top
    }
    
    
    
    func configTabbarHidingCells(){
        let footer = UIView(frame: CGRectMake(0, 0, 1, 50))
        footer.backgroundColor = UIColor.clearColor()
        self.tableView.tableFooterView = footer
    }
    
    func carregaQuestao(){
        self.tableView.reloadData()
        arrayAlternativas.removeAllObjects()
        arrayCell.removeAllObjects()
        
        
        while(arrayAlternativas.count < 5){
            let  rndNum = Int(arc4random_uniform(5))
            let letra = String(UnicodeScalar(65 + rndNum))
            
            if(!arrayAlternativas.containsObject((questao?.objectForKey("Alternativa\(letra)"))!)){
                arrayAlternativas.addObject((questao?.objectForKey("Alternativa\(letra)"))!)
            }
            
            
        }
        
        self.resposta = questao!.objectForKey("AlternativaA") as? String
        self.idQuestao = questao!.objectId!
        let tabBarController = self.tabBarController as! TabBarControllerExercicios
        
        tabBarController.nextBtn.enabled = false
        
        //        if(questoesManager.isFirstTime()){
        //            questoesManager.getQuestoes("Matematica", index:10 )
        //        }
        //
        //        arrayQuestoes.removeAllObjects()
        //        let questao = questoesManager.getQuestao()
        //        arrayQuestoes = questao.questoes
        //        self.resposta = questao.resposta
    }
    
    
    func makeSelectedCellWhite(){
        if  self.currentCell.backgroundColor != nil {
            self.currentCell.backgroundColor = UIColor.whiteColor()
            self.currentCell.labelLetra.textColor = UIColor.blackColor()
            self.currentCell.labelResposta.textColor = UIColor.blackColor()
        }
    }
    
    //    MARK: TableView
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func viewDidAppear(animated: Bool) {
        //        [self.tableView setContentOffset:CGPointZero animated:YES];
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("TOtal de alternativa\(arrayAlternativas.count)")
        return arrayAlternativas.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        
        let cell = tableView.dequeueReusableCellWithIdentifier("exercicioCell") as! PerguntasTableViewCell
        cell.textViewResposta.text = arrayAlternativas[indexPath.row] as? String
        
        
        cell.labelResposta.text = (String( UnicodeScalar ( 65 + indexPath.row)))
        cell.textViewResposta.layer.borderColor = UIColor.blueColor().colorWithAlphaComponent(0.5).CGColor
        cell.textViewResposta.layer.borderWidth = 0.5
        cell.textViewResposta.layer.cornerRadius = 6
        cell.textViewResposta.clipsToBounds = true
        
        
        
        if (arrayCell.count < 5) {
            arrayCell.addObject(cell)
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let tabBarController = self.tabBarController as! TabBarControllerExercicios
        
        tabBarController.nextBtn.enabled = true
        
        
        if(selected != nil){
            for cell in arrayCell {
                
                cell.setHighlighted(false, animated: false)
            }
        }
        
        
        selected = arrayCell.objectAtIndex(indexPath.row) as? PerguntasTableViewCell
        questoesManager.adicionaResposta((selected?.textViewResposta.text)!, index: questoesManager.contRespostas)
        
        print("INDEX DA CELL SELCECIONADA\(indexPath.row)")
        print("CELL SELECIONADA \(selected?.textViewResposta.text)")
        selected!.setHighlighted(true, animated: true)
    }
    
    func reloadTableView(){
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}