using UnityEngine;
using System.Collections;

public class VolumetricLightning : MonoBehaviour {

    public Material god_rays;
    public Material BlendCullings;
    public Material BlendLights;
    public Transform sphere;
    public Camera rendererCamera;
    public Shader cullObjectsShader;
    public Shader cullLightShader;



    void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        Vector3 pos = Camera.main.WorldToViewportPoint(sphere.position);
        god_rays.SetVector("light_pos", new Vector4(pos.x, pos.y, pos.z, 1));
       
        RenderTexture culledTexture = RenderTexture.GetTemporary(Screen.width, Screen.height);
        RenderTexture culledLight = RenderTexture.GetTemporary(Screen.width, Screen.height);
        RenderTexture lightTexture = RenderTexture.GetTemporary(Screen.width, Screen.height);
        
        // Seleccionar todos los objetos menos el sol
        rendererCamera.targetTexture = culledTexture;
        rendererCamera.RenderWithShader(cullObjectsShader, "RenderType");
        // Seleccionar el sol
        rendererCamera.targetTexture = culledLight;
        rendererCamera.RenderWithShader(cullLightShader, "Render");

//
//        // Debug
//        Graphics.Blit(culledLight, destination);
//
        // Unir el sol con los objetos
        BlendCullings.SetTexture("_Light", culledLight);
        Graphics.Blit(culledTexture, lightTexture, BlendCullings);

//
        // Aplicar el efecto loco y blendearlo con la imagen original
        god_rays.SetTexture("_SourceTex", source);
        Graphics.Blit(lightTexture, destination, god_rays);




        rendererCamera.targetTexture = null;
        culledTexture.Release();
        culledLight.Release();
        lightTexture.Release();
        
    }
}
