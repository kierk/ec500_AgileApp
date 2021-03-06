//
//  SwipeViewController.swift
//  aggle
//
// DEPRECATED DEPRECATED
// DEPRECATED DEPRECATED
// DEPRECATED DEPRECATED


import UIKit
import Firebase
class SwipeViewController: UIViewController {
    
    let ref = Firebase(url:"https://aggle2.firebaseio.com/")
    //--------------------------------------------------------------------------------------------------//
    var score: Int!
    var done: Bool = false
    
    //--------------------------------------------------------------------------------------------------//
    var pictureViews: [PictureView] = []
    var currentPictureView: PictureView!
    
    
    // Create a variable called data.  (String, Bool) -> Statement, Answer
    var data: [(String, Bool)] = [
        ("crock_20", true),
        ("speakers_45", true),
        ("pomsky", false),
        ("lawn_500", true),
    ]
    //--------------------------------------------------------------------------------------------------//
    
    
    
    //--------------------------------------------------------------------------------------------------//
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Aggle"
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        self.navigationController?.navigationBar.barTintColor = UIColor.redColor()
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Settings", style: .Plain, target: self, action: #selector(SwipeViewController.setBttnTouched(_:)))
        
        
        // Start with a 0 score
        score = 0
        
        for (question, answer) in self.data {
            if answer == true{
                currentPictureView = PictureView(
                    frame: CGRectMake(0, 0, self.view.frame.width - 50, self.view.frame.width + 50),
                    picture: question,
                    answer: answer,
                    center: CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.height / 2)
                )
                self.pictureViews.append(currentPictureView)
            }
        }
        
        for pictureView in self.pictureViews {
            self.view.addSubview(pictureView)
        }
        
        // Add Pan Gesture Recognizer
        let pan = UIPanGestureRecognizer(target: self, action: #selector(SwipeViewController.handlePan(_:)))
        self.view.addGestureRecognizer(pan)
    }
    //--------------------------------------------------------------------------------------------------//
    
    func setBttnTouched(sender: UIBarButtonItem) {
        
        performSegueWithIdentifier("swipeSettingsSegue", sender: self)
        
    }
    
    
    //--------------------------------------------------------------------------------------------------//
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //--------------------------------------------------------------------------------------------------//
    
    
    
    //--------------------------------------------------------------------------------------------------//
    func determineJudgement(answer: Bool) {
        let temp = ref.authData.uid
        
        if answer == true{
            let likesRef = ref.childByAppendingPath("UsersDB/" + (temp) + "/" + "Likes").childByAutoId()
            
            likesRef.setValue("testing")
        }
        
        else{
            let disLikesRef = ref.childByAppendingPath("UsersDB/" + (temp) + "/" + "Dislikes").childByAutoId()
            disLikesRef.setValue("dislikesTesting")
        }
        
        // Run the swipe animation
        self.currentPictureView.swipe(answer)
        
        // Handle when we have no more matches
        self.pictureViews.removeAtIndex(self.pictureViews.count - 1)
        if self.pictureViews.count - 1 < 0 {
            let noMoreView = PictureView(
                frame: CGRectMake(0, 0, self.view.frame.width - 50, self.view.frame.width + 50),
                picture: "x",
                answer: false,
                center: CGPoint(x: self.view.bounds.width / 2, y: self.view.bounds.height / 2)
            )
            self.pictureViews.append(noMoreView)
            self.view.addSubview(noMoreView)
            self.done = true
            
            return
        }
        
        // Set the new current question to the next one
        self.currentPictureView = self.pictureViews.last!
        
    }
    //--------------------------------------------------------------------------------------------------//
    
    
    
    //--------------------------------------------------------------------------------------------------//
    func handlePan(gesture: UIPanGestureRecognizer) {
        // Is this gesture state finished??
        if gesture.state == UIGestureRecognizerState.Ended {
            // Determine if we need to swipe off or return to center
            _ = gesture.locationInView(self.view)
            if self.currentPictureView.center.x / self.view.bounds.maxX > 0.8 {
                self.determineJudgement(true)
            }
            else if self.currentPictureView.center.x / self.view.bounds.maxX < 0.2 {
                self.determineJudgement(false)
            }
            else {
                self.currentPictureView.returnToCenter()
            }
        }
        let translation = gesture.translationInView(self.currentPictureView)
        self.currentPictureView.center = CGPoint(x: self.currentPictureView!.center.x + translation.x, y: self.currentPictureView!.center.y + translation.y)
        gesture.setTranslation(CGPointZero, inView: self.view)
    }
    //--------------------------------------------------------------------------------------------------//
}

