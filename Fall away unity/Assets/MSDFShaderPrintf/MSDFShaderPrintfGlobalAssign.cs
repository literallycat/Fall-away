using UnityEngine;


[UdonBehaviourSyncMode(BehaviourSyncMode.Manual)]
public class MSDFShaderPrintfGlobalAssign : MonoBehaviour
{
	public Texture MSDFAssignTexture;

	void Start()
	{
		int id = VRCShader.PropertyToID("_UdonMSDFPrintf"); 
		VRCShader.SetGlobalTexture( id, MSDFAssignTexture );
	}
}
