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

    @IBOutlet weak var changeText: UITextField!
    @IBOutlet var sceneView: ARSCNView!
    //keeping an instance of spaceship available for other functions
    var spaceShip: SCNNode?
    var baseNode: SCNNode?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        //Creates Text Geometry with thickness
        let text = SCNText(string: "Test", extrusionDepth: 1)
        
        //Creates a material object and adds to text
        let material = SCNMaterial()
        
        material.diffuse.contents = UIColor.white
        
        text.materials = [material]
        
        let baseNode = SCNNode()
        
        //Sets position of Node object
        baseNode.position = SCNVector3(x: 0, y: 0.02, z: -0.1)
        
        //Sets scale of Node object
        baseNode.scale = SCNVector3(x: 0.01, y: 0.01, z: 0.01)
        
        //Adds node to the sceneview
        sceneView.scene.rootNode.addChildNode(baseNode)
        
        //Add shadows
        sceneView.autoenablesDefaultLighting = true
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
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
        
        //Creates Text Geometry with thickness
        let newText = SCNText(string: "Test1", extrusionDepth: 1)
        
        //Creates a material object and adds to text
        let material = SCNMaterial()
        
        material.diffuse.contents = UIColor.green
        
        newText.materials = [material]
        
        let newNode = SCNNode()
        
        //Sets position of Node object
        newNode.position = hitPosition
        
        //Sets scale of Node object
        newNode.scale = SCNVector3(x: 0.01, y: 0.01, z: 0.01)
        
        newNode.geometry = newText
        
        print("Placing object")
        //Adds node to the sceneview
        sceneView.scene.rootNode.addChildNode(newNode)
        
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
