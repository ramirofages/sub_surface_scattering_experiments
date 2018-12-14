using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class NewBehaviourScript : MonoBehaviour {

    RenderTexture depth_rt;
    RenderTexture depth_difference_rt;

    public Camera off_camera;
    public Transform light_transform;
    Shader depth_prepass_shader;

    void Start()
    {
        depth_prepass_shader = Shader.Find("depth_prepass_shader");

        depth_rt = new RenderTexture(Screen.width, Screen.height, 32, RenderTextureFormat.ARGBFloat);
    }

    void OnPreRender() {
        Shader.SetGlobalVector("_DepthDifferenceSize", new Vector2(depth_rt.width, depth_rt.height));
        Shader.SetGlobalVector("_LightPos", off_camera.transform.position);
        Shader.SetGlobalVector("_CameraPos", Camera.main.transform.position);
        off_camera.targetTexture = depth_rt;
        Shader.SetGlobalMatrix("_ToLight", GL.GetGPUProjectionMatrix(off_camera.projectionMatrix,true) * off_camera.worldToCameraMatrix);
        off_camera.RenderWithShader(depth_prepass_shader, "");
        Shader.SetGlobalVector("_LightPosition", light_transform.position);


        Shader.SetGlobalTexture("_DepthDifference", depth_rt);

        off_camera.targetTexture = null;


    }
//
//    void OnRenderImage(RenderTexture src, RenderTexture dst)
//    {
//        Graphics.Blit(depth_rt, dst);
//    }

    void OnGUI()
    {

    }
        
    void OnDisable()
    {
        depth_rt.Release();
    }
}
