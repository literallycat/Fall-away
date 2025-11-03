// FontGen by the high gman

using System;
using UnityEditor;
using UnityEngine;

namespace MSDFShaderPrintf
{
    public class TextGen : EditorWindow
    {

        public string inputPath;
        public string outputPath;
        public string text = "Assets/";
        [MenuItem("Window/TextGen")]
        public static void ShowWindow()
        {
            GetWindow(typeof(TextGen));
        }
        private void OnGUI()
        {
            GUILayout.Label("Text Generator");
            outputPath = EditorGUILayout.TextField("Output Path", outputPath);
            text = EditorGUILayout.TextArea(text, GUILayout.Height(100));
        
            if (GUILayout.Button("Generate"))
            {
                var textOut = GenTexInfo();
                Debug.Log(String.Join(", ",textOut));
                CreateTexture(textOut);
            }
        }

        private int[] GenTexInfo()
        {
            int maxlinelen = 0;
            int chaid;
            string fieldText = text;
            int length = fieldText.Length;
            int x = 0, y = 0;
            for( chaid = 0; chaid < length; chaid++ )
            {
                int c = System.Convert.ToInt32( fieldText[chaid] );
                if( c == 10 )
                {
                    y++;
                    x = 0;
                }
                else
                {
                    if( x > maxlinelen ) maxlinelen = x;
                    x++;
                }
            }
		
            int w = maxlinelen + 1;
            int h = y + 1;
            Debug.Log(String.Join(", ", w, h));
				
            int [] fa = new int[w*h+2];
            fa[0] = w;
            fa[1] = h;
            x = 0;
            y = 0;
            
            int i;
            for( chaid = 0; chaid < fieldText.Length; chaid++ )
            {
                int c = System.Convert.ToInt32( fieldText[chaid] );
                if( c == 10 )
                {
                    y++;
                    x = 0;
                }
                else
                {
                    int index = x+y*w+2;
                    if( index < fa.Length )
                        fa[index] = c;
                    x++;
                }
            }
        
            return fa;
        }
        private void CreateTexture(int[] arr)
        {
            Texture2D tex = new Texture2D(arr.Length, 1, TextureFormat.RGBA32, false,true);
            tex.filterMode = FilterMode.Point;
            tex.anisoLevel = 0;
            for (int i = 0; i < arr.Length; i++)
            {
                float redval = arr[i] / 255.0f;
                tex.SetPixel(i, 0, new Color(redval, 0f, 0f, 255f));
            }
            tex.Apply(); 
            AssetDatabase.CreateAsset(tex,  outputPath +".asset");
            AssetDatabase.SaveAssets();
            AssetDatabase.Refresh();
       
        }
    }
} 