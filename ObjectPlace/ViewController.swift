//
//  ViewController.swift
//  ObjectPlace
//
//  Created by Rahul Sarathy on 1/25/18.
//  Copyright © 2018 Rahul Sarathy. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    //keeping an instance of spaceship available for other functions
    var spaceShip: SCNNode?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        // Create a new scene
        let scene = SCNScene(named: "art.scnassets/ship.scn")!
        //searches the child nodes of the scene object and returns a node with the node specified
      self.spaceShip = scene.rootNode.childNode(withName:"shipMesh", recursively: true)
         spaceShip?.position.z = -1
        //instead do SCNVector3Make
        //constructs a SCNVector3 object with position 0,0,-1
        self.spaceShip?.position = SCNVector3Make(0, 0, -1)
        // Set the scene to the view
        //sceneView.scene = scene
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //guard in case touches.first returns null
        //i think this essentially gets the touch object
        guard let touch = touches.first else { return }
        //results is an array of ARHitTestResult objects at the passed in point
        let results = sceneView.hitTest(touch.location(in: sceneView), types: [ARHitTestResult.ResultType.featurePoint])
        //takes one point from results
        guard let hitFeature = results.last else { return }
        //shoots a ray from the 2d coordinates to intersect with a 3d detected object
        let hitTransform = SCNMatrix4(hitFeature.worldTransform)
        //change hitposition to the new 3d coordinates
        let hitPosition = SCNVector3Make(hitTransform.m41, hitTransform.m42, hitTransform.m43)
        
        let newSpaceShip = spaceShip!.clone()
        newSpaceShip.position = hitPosition
        sceneView.scene.rootNode.addChildNode(newSpaceShip)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    // MARK: - ARSCNViewDelegate
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
