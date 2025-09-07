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
                    triangle_count += 1
                    x0, x1, x2 = poly.vertices
                    v0 = world_matrix @ temp.vertices[x0].co
                    v1 = world_matrix @ temp.vertices[x1].co
                    v2 = world_matrix @ temp.vertices[x2].co
                    data = (lambda v0, v1, v2: ",".join(f"({v.x:.9f}, {v.y:.9f}, {v.z:.9f})" for v in (v0, v1, v2)) + "\n")(v0, v1, v2)
                    f.write(data)
                bpy.data.meshes.remove(temp)
                objdata.to_mesh_clear()
    print(f"{tcount} triangles exported, wedge-ified becomes {tcount*2} wedges")
