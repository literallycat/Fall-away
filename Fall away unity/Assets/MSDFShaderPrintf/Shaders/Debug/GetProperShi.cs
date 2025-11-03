using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GetProperShi : MonoBehaviour
{
    public Material mat;               // material using the shader
    public Texture2D sourceTexture;    // 64×1 texture assigned to _MainTex

    // Size of the render target – 1×1 is enough if you only need one texel
    private RenderTexture rt;

    void Awake()
    {
        rt = new RenderTexture(1, 1, 0, RenderTextureFormat.ARGB32);
        rt.enableRandomWrite = false;
        rt.Create();
    }
    // Start is called before the first frame update
    void Start()
    {
        // Set the source texture on the material
        mat.SetTexture("_MainTex", sourceTexture);

        // Render a full‑screen quad into the 1×1 RenderTexture
        Graphics.Blit(null, rt, mat);

        // Read the pixel back to the CPU
        RenderTexture.active = rt;
        Texture2D readBack = new Texture2D(1, 1, TextureFormat.RGBA32, false);
        readBack.ReadPixels(new Rect(0, 0, 1, 1), 0, 0);
        readBack.Apply();
        RenderTexture.active = null;

        Color result = readBack.GetPixel(0, 0);
        Debug.Log($"Shader output – R:{result.r} G:{result.g} B:{result.b} A:{result.a}");
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
