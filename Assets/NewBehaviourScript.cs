using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class NewBehaviourScript : MonoBehaviour {

    RenderTexture depth_rt;
    RenderTexture depth_difference_rt;

    public Camera off_camera;

    Shader depth_prepass_shader;
    Shader depth_difference_shader;

    void Start()
    {
        depth_prepass_shader = Shader.Find("depth_prepass_shader");
        depth_difference_shader = Shader.Find("depth_difference");

        depth_rt = new RenderTexture(Screen.width, Screen.height, 32, RenderTextureFormat.ARGBFloat);
        depth_difference_rt = new RenderTexture(Screen.width, Screen.height, 32, RenderTextureFormat.ARGBFloat);
    }

    void OnPreRender() {

        Shader.SetGlobalVector("_LightPos", off_camera.transform.position);
        Shader.SetGlobalVector("_CameraPos", Camera.main.transform.position);
        off_camera.targetTexture = depth_rt;
        Shader.SetGlobalMatrix("_ToLight", GL.GetGPUProjectionMatrix(off_camera.projectionMatrix,true) * off_camera.worldToCameraMatrix);
        off_camera.RenderWithShader(depth_prepass_shader, "");

        Shader.SetGlobalTexture("_DepthPrepass", depth_rt);
        off_camera.targetTexture = depth_difference_rt;
        off_camera.RenderWithShader(depth_difference_shader, "");

        Shader.SetGlobalTexture("_DepthDifference", depth_difference_rt);

        off_camera.targetTexture = null;


    }
        
    void OnDisable()
    {
        depth_rt.Release();
        depth_difference_rt.Release();
    }
}
