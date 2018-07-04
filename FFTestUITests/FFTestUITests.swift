//
//  FFTestUITests.swift
//  FFTestUITests
//

import XCTest

class FFTestUITests: XCTestCase {
    
    let app = XCUIApplication()
    let serviceTimeout = 30
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    


    // Verify, news stories has image, headline, theAbstract and byLine on index screen
    func testElementsExistOnIndexScreen() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let mainTableView = app.tables["newsTableView"]
        let exists = NSPredicate(format: "exists == true")
        
        expectation(for: exists, evaluatedWith: mainTableView, handler: nil)
        waitForExpectations(timeout: TimeInterval(serviceTimeout), handler: nil)
      
        XCTAssert(mainTableView.exists,"main table view containing news cells doesn't exist")
        
        let newsCellAtIndex0 = mainTableView.cells["NewsCell0"]
        expectation(for: exists, evaluatedWith: newsCellAtIndex0, handler: nil)
        waitForExpectations(timeout: TimeInterval(serviceTimeout), handler: nil)
        
        XCTAssert(newsCellAtIndex0.staticTexts["headline"].exists, "Headline for first news cell doesn't exist")
        XCTAssert(newsCellAtIndex0.staticTexts["abstract"].exists, "Abstract for first news cell doesn't exist")
        XCTAssert(newsCellAtIndex0.staticTexts["byLine"].exists, "by line for first news cell doesn't exist")
        XCTAssert(newsCellAtIndex0.images["relatedImage"].exists,"Image doesn't exist")

    }
    
    //Verify, index screen has no more than 10 articles even when service has returned more than 10. at the moment, given endpoint seems to be returning 16 but index screen only shows 10 as expected.
    //Below test will continue swiping up as long as new cells are found. after multiple swiping, if no new cell is found then loop will exit and test will check total number of cells. if they exceed 10 then test fails
    func testIndexScreenHasNoMoreThan10Articles(){
        
        let mainTableView = app.tables["newsTableView"]
        let exists = NSPredicate(format: "exists == true")
        
        expectation(for: exists, evaluatedWith: mainTableView, handler: nil)
        waitForExpectations(timeout: TimeInterval(serviceTimeout), handler: nil)
        
        XCTAssert(mainTableView.exists,"main table view containing news cells doesn't exist")
        
        //wait for first new item to load
        expectation(for: exists, evaluatedWith: mainTableView.cells["NewsCell0"], handler: nil)
        waitForExpectations(timeout: TimeInterval(serviceTimeout), handler: nil)
        
        var i: Int = 0
        var isFinish : Bool = false
        var ValueOfiBeforeSwipe: Int = 0
        repeat {
            
            if mainTableView.cells["NewsCell\(i)"].exists {
                i+=1
            }else {
                if ValueOfiBeforeSwipe != i {
                    mainTableView.swipeUp()
                    ValueOfiBeforeSwipe = i
                }else {
                    isFinish = true
                }
                
            }
            print(i)
        }while isFinish == false
        
        XCTAssert(i <= 10, "Table view has more than 10 articles! Expected is less than or equal to 10")
      
        
    }
    
    //Verify, tapping a story should take user to full article
    func testGoToFullArticle() {
        let mainTableView = app.tables["newsTableView"]
        let exists = NSPredicate(format: "exists == true")
        expectation(for: exists, evaluatedWith: mainTableView, handler: nil)
        waitForExpectations(timeout: TimeInterval(serviceTimeout), handler: nil)
        
        XCTAssert(mainTableView.exists,"main table view containing news cells doesn't exist")
        let newsCellAtIndex0 = mainTableView.cells["NewsCell0"]
        expectation(for: exists, evaluatedWith: newsCellAtIndex0, handler: nil)
        waitForExpectations(timeout: TimeInterval(serviceTimeout), handler: nil)
        //tap on the first article
        newsCellAtIndex0.tap()

        //validations that app goes to next screen and web view exists there
        //it seems that actual content of the webview is not visible to the app object so, it can't be verified.
        //also, it is not a good idea to put asserts on actual content itself as it will make tests very fragile.
        XCTAssert(app.navigationBars["FFTest.WebView"].buttons["News"].exists, "App didn't navigate to full articles screen")
        XCTAssert(app.otherElements["ArticleWebView"].exists, "Web view doesn't exist")

        //go back to articles index screen
        app.navigationBars["FFTest.WebView"].buttons["News"].tap()
        
    }

}
