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
import FBSDKLoginKit
import FBSDKCoreKit

private let frameAnimationSpringBounciness: CGFloat = 9
private let frameAnimationSpringSpeed: CGFloat = 16
private let kolodaAlphaValueSemiTransparent: CGFloat = 0.1

class BackgroundAnimationViewController: UIViewController {
    
    //MARK: Properties
    @IBOutlet weak var kolodaView: CustomKolodaView!
    @IBOutlet var viewHeader: UIView!
    var invitados = [UsuarioModel]()
    var idFiesta = String()
    var idUsuarioMatch = String()
    var mensaje = String()
    var titulo = String()
    
    //MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        Common.shared.applyGradientView(view: self.viewHeader)
        ProgressOverlayView.shared.showProgressView(self.view)
        
        FiestaService.shared.filtrarInvitadosMeGustas(idFiesta: self.idFiesta) { idsAFiltrar in
            for idUsuario in idsAFiltrar {
                if let index = self.invitados.index(where: { $0.Id == idUsuario }) {
                    self.invitados.remove(at: index)
                }
            }
            if self.invitados.count == 0 {
                
                ProgressOverlayView.shared.hideProgressView()
                
                // El usuario no evaluó invitados de la fiesta y no hay invitados por evaluar
                if idsAFiltrar.count == 0 {
                    self.titulo = MeGustasService.QUIEN_TE_GUSTA
                    self.mensaje = MeGustasService.SIN_INVITADOS
                    self.performSegue(withIdentifier: "segueMeGustasSinResultados", sender: self)
                }
                // El usuario evaluó invitados de la fiesta y ya no quedan otros por evaluar
                else {
                    self.titulo = MeGustasService.QUIEN_TE_GUSTA
                    self.mensaje = MeGustasService.TODOS_EVALUADOS
                    self.performSegue(withIdentifier: "segueMeGustasSinResultados", sender: self)
                }
            }
            else {
                FacebookService.shared.completarDatosInvitadosFacebook(invitados: self.invitados) { success in }
                
                self.kolodaView.alphaValueSemiTransparent = kolodaAlphaValueSemiTransparent
                self.kolodaView.countOfVisibleCards = self.invitados.count
                self.kolodaView.delegate = self
                self.kolodaView.dataSource = self
                self.kolodaView.animator = BackgroundKolodaAnimator(koloda: self.kolodaView)
                
                self.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
            }
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: IBActions
    @IBAction func leftButtonTapped() {
        kolodaView?.swipe(.left)
    }
    
    @IBAction func rightButtonTapped() {
        kolodaView?.swipe(.right)
    }
    
    @IBAction func undoButtonTapped() {
        kolodaView?.revertAction()
    }
    
    @IBAction func matchesButtonTapped(_ sender: UIButton) {
        self.performSegue(withIdentifier: "segueMatches", sender: self)
    }
    
    
    @IBAction func goBack(_ sender: UIButton) {
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }
    
    //MARK: Custom functions
    func setInvitados(usuarios : [UsuarioModel]) {
        self.invitados = usuarios
    }
    
    func setIdFiesta(idFiesta: String) {
        self.idFiesta = idFiesta
    }
    
    func mostrarMatch(invitado: UsuarioModel) {
        self.idUsuarioMatch = invitado.Id
        
        let fotoPerfilInvitadoMatch = UIImageView(frame: CGRect(x: 10, y: 70, width: 250, height: 172))
        fotoPerfilInvitadoMatch.image = invitado.FotoPerfil.image
        fotoPerfilInvitadoMatch.contentMode = .scaleAspectFit
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.abrirPerfil(_:)))
        fotoPerfilInvitadoMatch.addGestureRecognizer(tap)
        fotoPerfilInvitadoMatch.isUserInteractionEnabled = true
        
        let spacer = "\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n\r\n"
        
        let alertController = UIAlertController(title: "¡Tenés un match!", message: invitado.Nombre + spacer, preferredStyle: UIAlertControllerStyle.alert)
        
        alertController.addAction(UIAlertAction(title: "Mis matches", style: UIAlertActionStyle.default)
        {
            (result : UIAlertAction) -> Void in
            self.performSegue(withIdentifier: "segueMatches", sender: self)
        })
        
        alertController.addAction(UIAlertAction(title: "Cerrar", style: UIAlertActionStyle.cancel) {
            (result : UIAlertAction) -> Void in
        })
        
        alertController.view.addSubview(fotoPerfilInvitadoMatch)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func abrirPerfil(_ sender: UITapGestureRecognizer) {
        FacebookService.shared.abrirPerfil(idUsuario: idUsuarioMatch)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueMatches" {
            let matchesViewController = segue.destination as! MatchesViewController
            matchesViewController.setIdFiesta(idFiesta: self.idFiesta)
        }
        if segue.identifier == "segueMeGustasSinResultados" {
            let meGustasSinResultadosViewController = segue.destination as! MeGustasSinResultadosViewController
            meGustasSinResultadosViewController.setMensaje(mensaje: self.mensaje)
            meGustasSinResultadosViewController.setTitulo(titulo: self.titulo)
        }
    }
}

//MARK: KolodaViewDelegate
extension BackgroundAnimationViewController: KolodaViewDelegate {
    
    func koloda(_ koloda: KolodaView, didSwipeCardAt index: Int, in direction: SwipeResultDirection) {
        let reaccion = direction == SwipeResultDirection.right
        MeGustasService.shared.guardarLikeOrNope(idFiesta: self.idFiesta,
                                          idInvitado: self.invitados[index].Id,
                                          like: reaccion) { success in
            if success {
                MeGustasService.shared.hayMatch(idFiesta: self.idFiesta,
                                         idInvitado: self.invitados[index].Id) { hayMatch in
                    if hayMatch {
                        self.mostrarMatch(invitado: self.invitados[index])
                    }
                }
            }
        }
    }
    
    func kolodaDidRunOutOfCards(_ koloda: KolodaView) {
        //kolodaView.resetCurrentCardIndex()
        self.mensaje = MeGustasService.TODOS_EVALUADOS
        self.performSegue(withIdentifier: "segueMeGustasSinResultados", sender: self)
    }
    
    func koloda(_ koloda: KolodaView, didSelectCardAt index: Int) {
        //Clic en card
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
        return self.invitados.count
    }
    
    func koloda(_ koloda: KolodaView, viewForCardAt index: Int) -> UIView {
        invitados[index].FotoPerfil.layer.cornerRadius = 10
        invitados[index].FotoPerfil.layer.masksToBounds = false
        invitados[index].FotoPerfil.clipsToBounds = true
        
        return invitados[index].FotoPerfil
        //return UIImageView(image: UIImage(named: "ic_meGustasCell.png"))
    }
    
    func koloda(_ koloda: KolodaView, viewForCardOverlayAt index: Int) -> OverlayView? {
        return Bundle.main.loadNibNamed("CustomOverlayView", owner: self, options: nil)?[0] as? OverlayView
    }
}
