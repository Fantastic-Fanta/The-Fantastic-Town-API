# Tutorial on how to import a Blender model into Town (or any F3X game)
## Introduction
This repository is **not** designed to be able to be ran and used straight out the box, this is due to a skill issue on my part not having a Windows PC, thus unable to get macros working on Windows. However from feedback of a few other people who attempted the macro, `pywin32` (https://pypi.org/project/pywin32/) should works the best out of a few mouse/keyboard libraries. 

## Demonstration
https://www.youtube.com/watch?v=l-BSNzQUWrY

## Main Principle Of Exporting
The main principle of how this works is using the fact that any scalene triangle is able to be disected into 2 right-angle triangles (or wedges as called in Roblox), here's a commented function on how the maths would work if you can't be bothered to maths it yourself, a copy of this is also in this directory named `TrianglesToWedges.py`:
```py
from numpy import array as arr, float64 as f64, dot, cross, linalg as linear
from math import atan2 as at, degrees as todeg, sqrt

def GenWedges(a,b,c): #a,b,c being vertices of a triangle
    a,b,c = arr(a, dtype=f64),arr(b, dtype=f64),arr(c, dtype=f64)
    ab,ac,bc = b-a,c-a,c-b
    abd,acd,bcd = dot(ab, ab),dot(ac, ac),dot(bc, bc)
    if abd > acd and abd > bcd:
        c,a = a.copy(),c.copy()
    elif acd > bcd and acd > abd:
        a,b = b.copy(),a.copy()
    ab,ac,bc = b-a,c-a,c-b

    vr = cross(ac, ab) #vec right
    vr /= linear.norm(vr) 
    vu = cross(bc, vr) #vec up
    vu /= linear.norm(vu)
    vb = bc / linear.norm(bc) #vec back
    h = abs(dot(ab, vu)) #height
    
    # wedge 1 size and cord
    s1 = (0.001, h, abs(dot(ab, vb))) #F3X decimal limit is 3
    c1 = (a + b) / 2

    #wedge 2 size and cord
    s2 = (0.001, h, abs(dot(ac, vb)))
    c2 = (a + c) / 2
    
    def CalcRotation(vr, vu, vb):
        ry = todeg(at(-vb[0], vb[2]))
        rx = todeg(at(vb[1], sqrt(vb[0]**2 + vb[2]**2)))
        rz = todeg(at(vr[1], vu[1]))
        return (rx, ry, rz)
    
    r1 = CalcRotation(vr, vu, vb)
    r2 = CalcRotation(-vr, vu, -vb)
    return (c1, s1, r1), (c2, s1, r2) #These data would work directly when inputted to F3X tools, rotation may need tweaking, size and position should be perfect
```
To use this, just import the function to your main macro module, iterate through a list of triangles, recommended to be exported to a csv/txt file first for easier management, although a direct input from Blender is also possible. After iteration, you would have a new list of wedges double the amount of your original triangle count. 

## Exporting Blender Model As Triangles
Now that the main principle is covered, the rest are relatively basic, getting a 3D model from Blender to a list of triangles makes use of Blender's built in Python scripting engine, this can be found in the top tab of Blender called `Scripting`, opening the tab will take you to an already setup Python console in Blender's own environment. Below is the code for triangulation and exporting, a copy can also be found in the current directory at `BlenderToTriangles.py`: 
```py
import bpy,bmesh
def TriangulateModel():
    with open("TriData.txt", 'w') as f:
        tcount = 0
        for obj in bpy.context.scene.objects:
            if obj.type == 'MESH':
                dgraph = bpy.context.evaluated_depsgraph_get()
                objdata = obj.evaluated_get(dgraph)
                meshdata = objdata.to_mesh()
                bm = bmesh.new()
                bm.from_mesh(meshdata)
                bmesh.ops.triangulate(bm, faces=bm.faces[:])
                temp = bpy.data.meshes.new("Temp")
                bm.to_mesh(temp)
                bm.free()
                world_matrix = objdata.matrix_world
                for poly in temp.polygons:
                    if len(poly.vertices) == 3:
                        triangle_count += 1
                        x0, x1, x2 = poly.vertices
                        v0 = world_matrix @ temp.vertices[x0].co
                        v1 = world_matrix @ temp.vertices[x1].co
                        v2 = world_matrix @ temp.vertices[x2].co
                        
                        data = f"({v0.x:.3f}, {v0.y:.3f}, {v0.z:.3f}),"\
                            f"({v1.x:.3f}, {v1.y:.3f}, {v1.z:.3f}),"\
                            f"({v2.x:.3f}, {v2.y:.3f}, {v2.z:.3f})\n"
                        f.write(data)
                bpy.data.meshes.remove(temp)
                objdata.to_mesh_clear()
    print(f"{tcount} triangles exported, wedge-ified becomes {tcount*2} wedges")
```
After saving the code to your project folder, find the absolute path of this file. To execute this code to Blender for quick tests, use this command 
```py
exec(compile(open("ur/file/path").read(),"the/same/file/path",'exec'))
```
## Macro
The way the macro works is very simple, following the order of `INSERT` -> `ROTATE` -> `MOVE` -> `RESIZE`, recommended to always leave `RESIZE` to the last step to avoid large parts getting stuck due to hitting plot boundaries. If any issue occurs with entering the values (coordinates, rotations and dimensions), it is likely a speed issue, try turning down your speed to see if the issue is still there, if it is, it shouldnt be.

## Extras
I have also uploaded a Blender file with the name `BoundingBox.blend.Zip` in the current directory, not very important but it contains the exact bounding box size of Town's 100x200 plot, with the base marked with a cross, relatively convenient to use for estimating sizes. Using multiple instances of Roblox to divide a high triangle count model up is also highly recommended as it can increase speed significantly.
