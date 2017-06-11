//
//  BackgroundAnimationViewController.swift
//  Koloda
//
//  Created by Eugene Andreyev on 7/11/15.
//  Copyright (c) 2015 CocoaPods. All rights reserved.
//

import UIKit
import Koloda
import pop

private let frameAnimationSpringBounciness: CGFloat = 9
private let frameAnimationSpringSpeed: CGFloat = 16
private let kolodaCountOfVisibleCards = 2
private let kolodaAlphaValueSemiTransparent: CGFloat = 0.1
var invitados = [UsuarioModel]()

class BackgroundAnimationViewController: UIViewController {
    
    //MARK: Properties
    @IBOutlet weak var kolodaView: CustomKolodaView!
    @IBOutlet var viewHeader: UIView!
    
    var myGroup = DispatchGroup()
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Common.applyGradientView(view: viewHeader)
        kolodaView.alphaValueSemiTransparent = kolodaAlphaValueSemiTransparent
        kolodaView.countOfVisibleCards = kolodaCountOfVisibleCards
        kolodaView.delegate = self
        kolodaView.dataSource = self
        kolodaView.animator = BackgroundKolodaAnimator(koloda: kolodaView)
        
        self.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: IBActions
    @IBAction func leftButtonTapped() {
        kolodaView?.swipe(.left)
        print("Nope")
    }
    
    @IBAction func rightButtonTapped() {
        kolodaView?.swipe(.right)
        print("Like")
    }
    
    @IBAction func undoButtonTapped() {
        kolodaView?.revertAction()
        print("Revert")
    }
    
    @IBAction func goBack(_ sender: UIButton) {
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }
    
    func setInvitados(usuarios : [UsuarioModel]){
        invitados = usuarios
    }
}

//MARK: KolodaViewDelegate
extension BackgroundAnimationViewController: KolodaViewDelegate {
    
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        kolodaView.resetCurrentCardIndex()
    }
    
    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
        let alertController = UIAlertController(title: "Ver perfil", message: "De " + invitados[index].Nombre, preferredStyle: UIAlertControllerStyle.alert)
        
        alertController.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.cancel) {
            (result : UIAlertAction) -> Void in
        })
        
        alertController.addAction(UIAlertAction(title: "Sí", style: UIAlertActionStyle.default)
        {
            (result : UIAlertAction) -> Void in
            UIApplication.shared.openURL(URL(string: "https://www.facebook.com/" + invitados[index].Id)!)
        })
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func kolodaShouldApplyAppearAnimation(_ koloda: KolodaView) -> Bool {
        return true
    }
    
    func kolodaShouldMoveBackgroundCard(_ koloda: KolodaView) -> Bool {
        return false
    }
    
    func kolodaShouldTransparentizeNextCard(_ koloda: KolodaView) -> Bool {
        return true
    }
    
    func koloda(kolodaBackgroundCardAnimation koloda: KolodaView) -> POPPropertyAnimation? {
        let animation = POPSpringAnimation(propertyNamed: kPOPViewFrame)
        animation?.springBounciness = frameAnimationSpringBounciness
        animation?.springSpeed = frameAnimationSpringSpeed
        return animation
    }
}

// MARK: KolodaViewDataSource
extension BackgroundAnimationViewController: KolodaViewDataSource {
    
    func kolodaSpeedThatCardShouldDrag(_ koloda: KolodaView) -> DragSpeed {
        return .default
    }
    
    func kolodaNumberOfCards(_ koloda: KolodaView) -> Int {
        return invitados.count
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        invitados[index].FotoPerfil.layer.cornerRadius = 10
        invitados[index].FotoPerfil.layer.masksToBounds = false
        invitados[index].FotoPerfil.clipsToBounds = true

        return invitados[index].FotoPerfil
    }
    
    func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
        return Bundle.main.loadNibNamed("CustomOverlayView", owner: self, options: nil)?[0] as? OverlayView
    }
}
