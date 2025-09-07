from numpy import\
  array as arr,\
  float64 as f64,\
  dot,\
  cross,\
  linalg as linear

from math import\
  atan2 as at,\
  degrees as todeg,\
  sqrt

def GenWedges(a,b,c):
    a,b,c = arr(a, dtype=f64),arr(b, dtype=f64),arr(c, dtype=f64)
    ab,ac,bc = b-a,c-a,c-b
    abd,acd,bcd = dot(ab, ab),dot(ac, ac),dot(bc, bc)
    if abd > acd and abd > bcd:
        c,a = a.copy(),c.copy()
    elif acd > bcd and acd > abd:
        a,b = b.copy(),a.copy()
    ab,ac,bc = b-a,c-a,c-b
    vr = cross(ac, ab)
    vr /= linear.norm(vr) 
    vu = cross(bc, vr)
    vu /= linear.norm(vu)
    vb = bc / linear.norm(bc)
    h = abs(dot(ab, vu))
    s1,c1 = (0.001, h, abs(dot(ab, vb))),(a + b) / 2
    s2,c2 = (0.001, h, abs(dot(ac, vb))),(a + c) / 2
    CalcRotation = lambda vr, vu, vb: (
        todeg(at(vb[1], sqrt(vb[0]**2 + vb[2]**2))),
        todeg(at(-vb[0], vb[2])),
        todeg(at(vr[1], vu[1]))
    )
    r1 = CalcRotation(vr, vu, vb)
    r2 = CalcRotation(-vr, vu, -vb)
    return (c1, s1, r1), (c2, s1, r2)
