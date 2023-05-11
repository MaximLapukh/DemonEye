using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LookingEye : MonoBehaviour
{
    [SerializeField] Transform Target;
    [SerializeField] Vector2 MaxShift = new Vector2(0.5f, 0.5f);
    [SerializeField] Vector2 RatioShift = new Vector2(-1,-1);
    [SerializeField] MeshRenderer MeshRenderer;
    private Material Material;
    private Vector3 PlayerAboutEye;
    void Start()
    {
        Material = MeshRenderer.material;
    }
    void Update()
    {
        PlayerAboutEye = Target.position - transform.position;

        //x offset
        Vector3 playerAboutEyeX = Quaternion.AngleAxis(-transform.eulerAngles.y, Vector3.up) * PlayerAboutEye;
        float angleX = Vector3.Angle(playerAboutEyeX, Vector3.right);
        float pupilOffsetX = (angleX / 180) * (MaxShift.x * 2) - MaxShift.x;
        //y offset
        Vector3 playerAboutEyeY = Quaternion.AngleAxis(-transform.eulerAngles.x, Vector3.right) * PlayerAboutEye;
        float angleY = Vector3.Angle(playerAboutEyeY, Vector3.up);
        float pupilOffsetY = (angleY / 180) * (MaxShift.x * 2) - MaxShift.x;

        Material.SetVector("_PupilOffset", new Vector4(
            Mathf.Clamp(pupilOffsetX * RatioShift.x, -MaxShift.x, MaxShift.x),
            Mathf.Clamp(pupilOffsetY * RatioShift.y, -MaxShift.y, MaxShift.y), 
            0, 0));
    }
}
