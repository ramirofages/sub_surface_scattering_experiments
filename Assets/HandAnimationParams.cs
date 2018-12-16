using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class HandAnimationParams : MonoBehaviour {

    public float sphereRayIntensity;
    public float handLightIntensity;
    public float handAttenuation;
    public float rayDecay;
    public Material handMat;
    public Material rayMat;

	void Start () {
		
	}
	
	void Update () {
        rayMat.SetFloat("_Weight", sphereRayIntensity);
        rayMat.SetFloat("_Decay", rayDecay);
        handMat.SetFloat("_MaxDepth", handLightIntensity);
        handMat.SetFloat("_LightAttenuationDistance", handAttenuation);
	}
}
