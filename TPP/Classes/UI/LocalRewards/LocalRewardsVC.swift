//
//  LocalRewardsVC.swift
//  TPP
//
//  Created by Mihails Tumkins on 13/12/16.
//  Copyright © 2016 Chili. All rights reserved.
//

import UIKit
import Mapbox
import SnapKit
import RxSwift

class LocalRewardsVC: UIViewController {

    var eventPopupVC: EventPopupVC?
    var viewModel = LocalRewardsViewModel()
    let locationService = LocationService.shared

    //let userLocationAnnotation = MGLPointAnnotation()

    internal let bag = DisposeBag()

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()

        mapView.delegate = self
        mapView.alpha = 0.0
        mapView.showsUserLocation = true
        let defLocation = CLLocationCoordinate2DMake(42.36765, -71.0410541)
        mapView.setCenter(defLocation, zoomLevel: 16, animated: false)

        view.insertSubview(mapView, at: 0)

        mapView.snp.makeConstraints { (make) in
            make.edges.equalTo(view)
        }

        if locationService.isAuthorized() == false {
            self.locationService.authorize()
        }

        self.addHandlers()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.positionOnLastLocation()
        self.viewModel.refreshActivities()
    }

    @IBAction func didTapSettings(_ sender: Any) {
        showSettings()
    }

    func showSettings() {
        let vc: SettingsVC = UIStoryboard(storyboard: .Settings).instantiateViewController()
        vc.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(vc, animated: true)
    }

    lazy var mapView: MGLMapView = {
        let styleURL = URL(string: "mapbox://styles/jogolo/ciuymvf3q00gy2io43c5vu26i")!
        let mapView = MGLMapView(frame: self.view.bounds, styleURL: styleURL)
        return mapView
    }()
}

extension LocalRewardsVC {
    internal func addHandlers() {
        self.viewModel.errorHandler = {[weak self] error in
            if let error = error {
                self?.showTPPAlert(error: error)
            }
        }
        self.viewModel.cleanAnnotationsHandler = {[weak self] in
            if let annotations = self?.mapView.annotations {
                print("remove annotations")
                self?.mapView.removeAnnotations(annotations)
            }
        }

        self.viewModel.locations.asObservable()
            .skip(1)
            .subscribe(onNext: {[weak self] (locations) in
                self?.addAnnotations(locations)
                print("locations ", locations.count)
            }).addDisposableTo(self.bag)

        self.viewModel.foursquareLocations.asObservable()
            .skip(1)
            .subscribe(onNext: {[weak self] (locations) in
                self?.addAnnotations(locations)
                print("fsq locations ", locations.count)
            }).addDisposableTo(self.bag)

        self.viewModel.city.asObservable().skip(1).subscribe(onNext: {[weak self] (city) in
            self?.title = city
        }).addDisposableTo(self.bag)

        locationService.lastLocation.asObservable().subscribe(onNext: {[weak self] (location) in
            self?.updateLocation(location)
        }).addDisposableTo(self.bag)
    }

    private func addAnnotations(_ items: [Location]) {
        self.mapView.addAnnotations(
            items.filter { $0.coordinate != nil }.map {
                let annotation = MGLPointAnnotation()
                annotation.coordinate = $0.coordinate!
                annotation.title = $0.name
                return annotation
            }
        )
    }

    fileprivate func positionOnLastLocation() {
        if let location = self.locationService.lastLocation.value {
            let zoomLevel = mapView.zoomLevel < 16 ? 16 : mapView.zoomLevel
            self.mapView.setCenter(location.coordinate, zoomLevel: zoomLevel, animated: true)
        }
    }
}

extension LocalRewardsVC: MGLMapViewDelegate {

    var userImageName: String {
        return "user_annotation_icon"
    }

    func mapViewDidFinishLoadingMap(_ mapView: MGLMapView) {
        activityIndicator.stopAnimating()
        mapView.setZoomLevel(12, animated: true)
        UIView.animate(withDuration: 0.4, animations: {
           self.mapView.alpha = 1.0
        })
        self.positionOnLastLocation()
    }

    func mapView(_ mapView: MGLMapView, imageFor annotation: MGLAnnotation) -> MGLAnnotationImage? {
        /*if annotation.isEqual(userLocationAnnotation) {
            return MGLAnnotationImage(image: UIImage(named: userImageName)!, reuseIdentifier: userImageName)
        }*/

        if let item = viewModel.locations.value.filter({ return $0.coordinate == annotation.coordinate }).first {
            return getaAnnotationImage(item: item)
        }
        if let fsqItem = viewModel.foursquareLocations.value.filter({ return $0.coordinate == annotation.coordinate }).first {
            let annotationImage = getaAnnotationImage(item: fsqItem)
            if let image = annotationImage?.image {
                annotationImage?.image = image.withAlignmentRectInsets(UIEdgeInsets(top: 0, left: 0, bottom: image.size.height/2, right: 0))
            }
            return annotationImage
        }
        return nil
    }

    private func getaAnnotationImage(item: Location) -> MGLAnnotationImage? {
        var annotationImage = mapView.dequeueReusableAnnotationImage(withIdentifier: item.imageName)
        if annotationImage == nil {
            annotationImage = MGLAnnotationImage(image: item.image, reuseIdentifier: item.imageName)
        }
        return annotationImage
    }

    func mapView(_ mapView: MGLMapView, didSelect annotation: MGLAnnotation) {

        guard let item = viewModel.locations.value.filter({ $0.coordinate == annotation.coordinate }).first else {
            return
        }

        mapView.deselectAnnotation(annotation, animated: false)

        let vc = EventPopupVC()
        vc.modalPresentationStyle = .overFullScreen

        vc.configure(with: item)
        vc.delegate = self
        present(vc, animated: false, completion: nil)
        eventPopupVC = vc
    }

    func mapView(_ mapView: MGLMapView, annotationCanShowCallout annotation: MGLAnnotation) -> Bool {
        guard viewModel.locations.value.filter({ $0.coordinate == annotation.coordinate }).first == nil else {
            return false
        }
        return true
    }

    internal func updateLocation(_ location: CLLocation?) {
        guard let location = location else {
            return
        }
        self.viewModel.loadData(latitude: location.coordinate.latitude,
                                longitude: location.coordinate.longitude)
        if self.mapView.annotations == nil {
            self.viewModel.getCurrentCity(location: location)
            let zoomLevel = mapView.zoomLevel < 16 ? 16 : mapView.zoomLevel
            mapView.setCenter(location.coordinate, zoomLevel: zoomLevel, animated: true)
        }
    }
}

extension LocalRewardsVC: EventPopupDelegate {
    func didTapUnlock(activity: ActivityDO?) {
        eventPopupVC?.fadeOut() {
            self.eventPopupVC?.dismiss(animated: false, completion: nil)
            self.show(activity: activity)
        }
    }

    func didTapCancel() {
        eventPopupVC?.fadeOut() {
            self.eventPopupVC?.dismiss(animated: false, completion: nil)
        }
    }

    private func show(activity: ActivityDO?) {
        guard let activity = activity else {
            return
        }
        if let activityType = activity.activityType(), activity.content == nil {
            TPPCreateUserActivityEvent(target: self, type: activityType, progress: nil, error: { [weak self] error in
                self?.showTPPAlert(error: error)
                }, completion: { response in
                    TPPLoadActivityListEvent().send()
                    UIShowRewardsEvent().send()
            }).send()
        } else if activity.content != nil {
            let vc: ContentPageVC = UIStoryboard(storyboard: .Feed).instantiateViewController()
            vc.viewModel = ContentPageVCViewModel(item: activity)
            self.present(vc, animated: true, completion: nil)
        }
    }
}
