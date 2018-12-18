import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var menuBarView: MenuTabsView!
    lazy var subViewControllers:[UIViewController] = {
        return [
            UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController1") as! ViewController1,
            UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController2") as! ViewController2,
            UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController3") as! ViewController3,
            ]
    }()
    
    
    var currentIndex: Int = 0
    var tabs = ["Menu TAB 1","Menu TAB 2","Menu TAB 3"]
    var pageController: UIPageViewController!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        menuBarView.dataArray = tabs
        menuBarView.isSizeToFitCellsNeeded = true
        menuBarView.collView.backgroundColor = UIColor.init(white: 0.97, alpha: 0.97)
        
        presentPageVCOnView()
        
        menuBarView.menuDelegate = self
        pageController.delegate = self
        pageController.dataSource = self
        
        //For Intial Display
        menuBarView.collView.selectItem(at: IndexPath.init(item: 0, section: 0), animated: true, scrollPosition: .centeredVertically)
        pageController.setViewControllers([subViewControllers[0]], direction: .forward, animated: true, completion: nil)
        
        // With CallBack Function...
        //menuBarView.menuDidSelected = myLocalFunc(_:_:)

    }
    
    
    /*
     // Call back function
    func myLocalFunc(_ collectionView: UICollectionView, _ indexPath: IndexPath) {
        
        
        if indexPath.item != currentIndex {
            
            if indexPath.item > currentIndex {
                self.pageController.setViewControllers([viewController(At: indexPath.item)!], direction: .forward, animated: true, completion: nil)
            }else {
                self.pageController.setViewControllers([viewController(At: indexPath.item)!], direction: .reverse, animated: true, completion: nil)
            }
            
            menuBarView.collView.scrollToItem(at: IndexPath.init(item: indexPath.item, section: 0), at: .centeredHorizontally, animated: true)
            
        }
        
    }
     */
 
    func presentPageVCOnView() {
        
        self.pageController = storyboard?.instantiateViewController(withIdentifier: "PageControllerVC") as! PageControllerVC
        self.pageController.view.frame = CGRect.init(x: 0, y: menuBarView.frame.maxY + 30, width: self.view.frame.width, height: self.view.frame.height - menuBarView.frame.maxY)
        self.addChildViewController(self.pageController)
        self.view.addSubview(self.pageController.view)
        self.pageController.didMove(toParentViewController: self)
        
    }
    
    //Present ViewController At The Given Index
    
    func viewController(At index: Int) -> UIViewController? {
        
        if((self.menuBarView.dataArray.count == 0) || (index >= self.menuBarView.dataArray.count)) {
            return nil
        }
        let contentVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ViewController1") as! ViewController1
        currentIndex = index
        return contentVC
    }
}


extension ViewController: MenuBarDelegate {

    func menuBarDidSelectItemAt(menu: MenuTabsView, index: Int) {
        if index != currentIndex {
            if index > currentIndex {
                self.pageController.setViewControllers([subViewControllers[index]], direction: .forward, animated: true, completion: nil)
            }else {
                self.pageController.setViewControllers([subViewControllers[index]], direction: .reverse, animated: true, completion: nil)
            }
            currentIndex = index
            menuBarView.collView.scrollToItem(at: IndexPath.init(item: index, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
}


extension ViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let currentIndex:Int = subViewControllers.index(of: viewController) ?? 0
        if (currentIndex <= 0) {
            return nil
        }
        return subViewControllers[currentIndex - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let currentIndex: Int = subViewControllers.index(of: viewController) ?? 0
        if( currentIndex >= subViewControllers.count - 1) {
            return nil
        }
        return subViewControllers[currentIndex + 1]
    }
   
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return subViewControllers.count
    }

    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {

        if finished {
            if completed {
                if (pageViewController.viewControllers![0] is ViewController1) {
                    currentIndex = 0
                }else if (pageViewController.viewControllers![0] is ViewController2 ){
                    currentIndex = 1
                }else if (pageViewController.viewControllers![0] is ViewController3){
                    currentIndex = 2
                }
                menuBarView.collView.selectItem(at: IndexPath.init(item: currentIndex  , section: 0), animated: true, scrollPosition: .centeredVertically)
                menuBarView.collView.scrollToItem(at: IndexPath.init(item: currentIndex  , section: 0), at: .centeredHorizontally, animated: true)
            }
        }

    }
    
}
