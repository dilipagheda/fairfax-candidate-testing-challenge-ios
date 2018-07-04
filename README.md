## Suggested Tests

1) Verify, stories has image, headline, theAbstract and byLine on index screen
Done. Passed.
2) Verify, index screen has no more than 10 articles
Done. Passed.
3) Verify, tapping a story should take user to full article
Done. Passed.


## Submission Notes

* Short description explaining design patterns used (e.g PageObjects, Navigator, Utilities...)

I have not used any design pattern in perticular as it is such a small app with only two screens. However, I would typically implement a page object pattern for larger apps. In page object pattern, there is one class with set of methods that represents a screen. Then, there is a wrapper class that contains methods containing calls to different methods of a class representing a screen.

* Explain what each test does in code comments or in document
Explanation is given in code comment.

* Test report, it could be generated or simply in document with pass/fail status
All 3 tests passed.

* If you had to modify Application/Product code for testability, mention the changes you made

I had to add accessiblity identifiers for cell elements such as header, iamge, by line and abstract in the storyboard.

also, I had to make below changes to application code to add accessibility identifiers.
```
class NewsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!;
    let newsLoadingSpinner: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
    let viewModel: NewsViewModel = NewsViewModel(apiRequestManager: FFTApiRequestManager(timeout: 5));
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        // set accessibility identifier for tableview
        tableView.accessibilityLabel = "newsTableView"
        tableView.isAccessibilityElement = true
        
        // Style TableView
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.tableFooterView = UIView(frame: .zero);
        
        // Style/Setup loading spinner
        self.setupLoadingSpinner();
        
        // Call api to get view content
        self.getNews();
    }
    ```
    
    ```
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.viewModel.newsTableViewCellIdentifier, for: indexPath) as! FFTNewsTableViewCell;
        cell.setupContent(news: self.viewModel.newsArray[indexPath.row]);
        
        cell.accessibilityIdentifier="NewsCell\(indexPath.row)"
        cell.isAccessibilityElement = true
        return cell;
    }
    
    ```
    
* Any 3rd party libraries used and rational ?

no

* Any additional tests done ? -- apart mentioned in 'suggested tests'

No. There is one test that can be possibly added which will verify the actual content on the screen. It can be implemented two ways 

(1) : add a function that will make a service call and store response in some object. then use data from it to assert content on the screen. 
(2) : use mock data and inject it in the view. then assert against known values.

* Any missing test automation coverage, because it couldn't be easily verified ?

Test to verify that items are displayed more recent to less recent. it can be implemented but it is more complex and need either of the above two approaches.
