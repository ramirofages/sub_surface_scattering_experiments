using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Rendering;

public class GodRays : MonoBehaviour {

    public Material sobel;
    public Material blur;
    public Material rays;
    public Material sharpen;

    public float speed = 1f;
    public float rotation = 1f;
    Vector3 start_pos;
    Quaternion start_rot;

    void Start()
    {
        start_pos = transform.position;
        start_rot = transform.rotation;
    }
    void Update()
    {
        float time = Time.time/5f;
        float dx_dy = Mathf.PerlinNoise(time, time + Time.deltaTime) - Mathf.PerlinNoise(time, time - Time.deltaTime);
        float dy_dx = Mathf.PerlinNoise(time + Time.deltaTime, time ) - Mathf.PerlinNoise(time - Time.deltaTime, time);
        Vector3 dir = new Vector3(dx_dy/2f, dy_dx/2f, 0);
        //transform.position = start_pos + dir * speed;

        Quaternion quat = Quaternion.AngleAxis(Mathf.Sin(Time.time) * rotation, Vector3.right);
        transform.rotation = start_rot * quat;
    }
	// Update is called once per frame
	void OnRenderImage(RenderTexture src, RenderTexture dst) {
        Graphics.Blit(src,dst, rays);
        //RenderTexture tmp = RenderTexture.GetTemporary(Screen.width, Screen.height,32, RenderTextureFormat.ARGB32);
        //sharpen.SetTexture("_Mask", caustics);
        //Graphics.Blit(caustics, dst);
        //Graphics.Blit(src, dst, sharpen);

//        Graphics.Blit(src,tmp, sobel);
//        Graphics.Blit(tmp,dst, blur);
        //RenderTexture.ReleaseTemporary(tmp);
	}

}
