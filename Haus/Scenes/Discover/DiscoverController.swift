
import UIKit
import SnapKit
import SkeletonView

class DiscoverController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var collectionView: UICollectionView!
    var viewModel = DiscoverViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .lightGray
        navigationController?.navigationBar.isHidden = true
        
        //navigationController?.navigationBar.backgroundColor = .red
        setupCollectionView()
        
        setupSwipeGesture()
        setupViewModelCallbacks()
        viewModel.fetchVideos()
        
        collectionView.showAnimatedGradientSkeleton()
    }
    
    private func setupViewModelCallbacks() {
        viewModel.error = { errorMessage in
            print("Error: \(errorMessage)")
        }
        
        viewModel.success = { [weak self] in
            self?.collectionView.hideSkeleton()
            self?.collectionView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.backgroundColor = .black
        tabBarController?.tabBar.barTintColor = .black
        tabBarController?.tabBar.tintColor = .white
        tabBarController?.tabBar.unselectedItemTintColor = .gray
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.barTintColor = .white
        tabBarController?.tabBar.backgroundColor = .white
        tabBarController?.tabBar.tintColor = .mainBlueColor
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
    }
    
    func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .black
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isPagingEnabled = true
        collectionView.contentInsetAdjustmentBehavior = .never
        
        collectionView.register(VideoCell.self, forCellWithReuseIdentifier: VideoCell.identifier)
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide)
            //.offset(-tabBarController!.tabBar.frame.height)
        }
    }
    
    func setupSwipeGesture() {
//        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipeGesture))
//        swipeGesture.direction = .down
//        collectionView.addGestureRecognizer(swipeGesture)
    }
    
    @objc func handleSwipeGesture() {
        print("Swiped down - load new video")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: VideoCell.identifier, for: indexPath) as! VideoCell
        let fileName = viewModel.videoFileName[indexPath.item % viewModel.videoFileName.count] // Ensure looping through videoFileName
        cell.configure(with: viewModel.items[indexPath.item], fileName: fileName)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionView.bounds.size
    }
}

extension UIColor {
    static func random() -> UIColor {
        return UIColor(
            red: CGFloat(drand48()),
            green: CGFloat(drand48()),
            blue: CGFloat(drand48()),
            alpha: 1.0
        )
    }
}
