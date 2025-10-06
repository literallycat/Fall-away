using UnityEngine;
public enum OPTIONS{
    forwards = 0,
        right = 1,
        up = 2
}
public class ApplyForce : MonoBehaviour
{
    Rigidbody m_Rigidbody;
    public float m_Thrust = 20f;
    public OPTIONS op;
    private Vector3 trans;

    void Start()
    {

        //Fetch the Rigidbody from the GameObject with this script attached
        m_Rigidbody = GetComponent<Rigidbody>();
        switch (op){
            case OPTIONS.forwards:
                trans = m_Rigidbody.transform.forward;
                break;
            case OPTIONS.right:
                trans = m_Rigidbody.transform.right;
                break;
            case OPTIONS.up:
                trans = m_Rigidbody.transform.up;
                break;
        }
    }

    void FixedUpdate()
    {
        m_Rigidbody.AddForce(trans * m_Thrust);



    }
}
