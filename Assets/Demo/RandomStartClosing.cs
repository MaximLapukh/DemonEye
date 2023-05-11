using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RandomStartClosing : MonoBehaviour
{
    private const string START_TR = "Start";
    [SerializeField] Animator Animator;
    private float _timer;

    void Start()
    {
        _timer = Random.value;
    }
    void Update()
    {
        if (_timer < 0)
        { Animator.SetTrigger(START_TR);
            _timer = 0;
        }
        if(_timer >0) _timer -= Time.deltaTime;
    }
}
