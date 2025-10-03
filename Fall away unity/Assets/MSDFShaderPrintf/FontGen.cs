// FontGen by the high gman
using System;
using UnityEngine;
using System.Collections;
using System.Linq;
using UnityEditor;


public class FontGen : EditorWindow
{

    public string inputPath;
    public string outputPath;
    [MenuItem("Window/FontGen")]
    public static void ShowWindow()
    {
        GetWindow(typeof(FontGen));
    }
    private void OnGUI()
    {
        GUILayout.Label("Font Generator");
        outputPath = EditorGUILayout.TextField("Output Path", outputPath);
        if (GUILayout.Button("Generate"))
        {
            Create2DArray();
        }
    }

    private void Create2DArray()
    {
        var texArray = new Texture2DArray(32, 64, 256,TextureFormat.RGB24, false);
        var blankTex = genBlack();
        for (int i = 0; i < 255; i++)
        {
            if (i == 9 || i == 10 || i == 13 || i == 0 || i == 32)
            {
                texArray.SetPixels(blankTex.GetPixels(),i);
                continue;
            }
            var texturePath = $"Assets/MSDFShaderPrintf/.temp/m{i.ToString("D3")}.png";
            
            Texture2D tex = new Texture2D(32, 64, TextureFormat.RGB24, false);
            ImageConversion.LoadImage(tex, System.IO.File.ReadAllBytes(texturePath));
            
            texArray.SetPixels(tex.GetPixels(),i);
            
        }
        texArray.Apply();
        AssetDatabase.CreateAsset(texArray, outputPath);
        AssetDatabase.SaveAssets();
        AssetDatabase.Refresh();
        

    }
    private Texture2D genBlack()
    {
        var texture = new Texture2D(32, 64, TextureFormat.RGB24, false);
        Color[] pixels = Enumerable.Repeat(Color.black,Screen.width * Screen.height).ToArray();
        texture.SetPixels(pixels);
        texture.Apply();
        return texture;

    }
} 