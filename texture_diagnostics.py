from pathlib import Path
from PIL import Image, ImageStat

root = Path.home() / "AppData/Local/Temp/m230_shader_diagnostic"
for path in sorted(root.glob("*.png")):
    image = Image.open(path).convert("RGBA")
    stats = ImageStat.Stat(image)
    extrema = image.getextrema()
    nonblack = sum(1 for pixel in image.getdata() if max(pixel[:3]) > 2) / (image.width * image.height)
    means = tuple(round(value, 1) for value in stats.mean)
    print(f"{path.name:31} mean={means} extrema={extrema} nonblack={nonblack:.3f}")
