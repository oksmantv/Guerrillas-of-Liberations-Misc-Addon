import bpy
from collections import Counter
from array import array

paths = (
    r"P:\OKS_GOL_Misc\data\models\OKS_M230_Chaingun.p3d",
    r"P:\OKS_GOL_Misc\data\models\M230ChainGun_Export_Version_3.p3d",
)

for path in paths:
    bpy.ops.object.select_all(action="SELECT")
    bpy.ops.object.delete()
    print("MODEL", path)
    bpy.ops.a3ob.import_p3d(
        filepath=path,
        first_lod_only=True,
        enclose=False,
        groupby="NONE",
        sections="PRESERVE",
        proxy_action="NOTHING",
        additional_data={"NORMALS", "SELECTIONS", "UV", "MATERIALS"},
    )
    for obj in bpy.context.scene.objects:
        if obj.type != "MESH":
            continue
        print("OBJECT", obj.name, "verts", len(obj.data.vertices), "faces", len(obj.data.polygons), "materials", len(obj.material_slots))
        counts = [0] * len(obj.material_slots)
        for polygon in obj.data.polygons:
            if polygon.material_index < len(counts):
                counts[polygon.material_index] += 1
        for index, slot in enumerate(obj.material_slots):
            material = slot.material
            props = getattr(material, "a3ob_properties_material", None) if material else None
            print("MATERIAL", index, "faces", counts[index], "name", material.name if material else "", "texture", props.texture_path if props else "", "rvmat", props.material_path if props else "")
        if path.endswith("M230ChainGun_Export_Version_3.p3d"):
            duplicate_keys = Counter()
            degenerate_by_material = Counter()
            opposed_loops_by_material = Counter()
            loops_by_material = Counter()
            for polygon in obj.data.polygons:
                coordinates = tuple(sorted(tuple(round(value, 6) for value in obj.data.vertices[index].co) for index in polygon.vertices))
                duplicate_keys[(polygon.material_index, coordinates)] += 1
                if polygon.area < 1e-10:
                    degenerate_by_material[polygon.material_index] += 1
                for loop_index in polygon.loop_indices:
                    loops_by_material[polygon.material_index] += 1
                    if obj.data.corner_normals[loop_index].vector.dot(polygon.normal) < 0:
                        opposed_loops_by_material[polygon.material_index] += 1
            duplicate_faces = Counter()
            for (material_index, _), count in duplicate_keys.items():
                if count > 1:
                    duplicate_faces[material_index] += count
            for index in range(len(obj.material_slots)):
                print("GEOMETRY", index, "duplicate_faces", duplicate_faces[index], "degenerate_faces", degenerate_by_material[index], "opposed_corner_normals", opposed_loops_by_material[index], "of", loops_by_material[index])
            group = obj.vertex_groups.get("pylonstructure")
            if group:
                member_vertices = {
                    vertex.index
                    for vertex in obj.data.vertices
                    if any(item.group == group.index and item.weight > 0 for item in vertex.groups)
                }
                any_counts = Counter()
                all_counts = Counter()
                for polygon in obj.data.polygons:
                    vertices = set(polygon.vertices)
                    if vertices & member_vertices:
                        any_counts[polygon.material_index] += 1
                    if vertices and vertices <= member_vertices:
                        all_counts[polygon.material_index] += 1
                print("PYLON_STRUCTURE", "vertices", len(member_vertices), "touching_faces", dict(any_counts), "full_faces", dict(all_counts))
                for atlas, suffix, channel in (
                    ("BarrelBoxBeltFeed", "co", None),
                    ("BarrelBoxBeltFeed", "as", 1),
                    ("FrameAndHeatguard", "co", None),
                    ("FrameAndHeatguard", "as", 1),
                ):
                    image = bpy.data.images.load(rf"C:\Users\aleok\AppData\Local\Temp\m230_shader_diagnostic\{atlas}_{suffix}.png", check_existing=False)
                    pixels = array("f", [0.0]) * (image.size[0] * image.size[1] * 4)
                    image.pixels.foreach_get(pixels)
                    samples = []
                    uv_data = obj.data.uv_layers.active.data
                    for polygon in obj.data.polygons:
                        if polygon.material_index != 0 or not set(polygon.vertices) <= member_vertices:
                            continue
                        u = sum(uv_data[index].uv.x for index in polygon.loop_indices) / len(polygon.loop_indices)
                        v = sum(uv_data[index].uv.y for index in polygon.loop_indices) / len(polygon.loop_indices)
                        x = min(image.size[0] - 1, max(0, int((u % 1.0) * image.size[0])))
                        y = min(image.size[1] - 1, max(0, int((v % 1.0) * image.size[1])))
                        offset = (y * image.size[0] + x) * 4
                        if channel is None:
                            samples.append(sum(pixels[offset:offset + 3]) / 3)
                        else:
                            samples.append(pixels[offset + channel])
                    ordered = sorted(samples)
                    print(
                        "PYLON_TEXTURE", atlas, suffix,
                        "samples", len(samples),
                        "mean", round(sum(samples) / len(samples), 4),
                        "p10", round(ordered[len(ordered) // 10], 4),
                        "median", round(ordered[len(ordered) // 2], 4),
                        "below_0.25", round(sum(value < 0.25 for value in samples) / len(samples), 4),
                        "min", round(min(samples), 4),
                        "max", round(max(samples), 4),
                    )
                    bpy.data.images.remove(image)
            else:
                print("PYLON_STRUCTURE missing", [item.name for item in obj.vertex_groups if "pylon" in item.name.lower()])
