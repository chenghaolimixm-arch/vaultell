"""Generate production icon assets from the approved H4 design.

Run:  python generate_app_assets.py
Writes directly into the Flutter app's android/ios/assets folders.
"""

import os
from PIL import Image, ImageDraw, ImageFilter

from generate_concepts import (
    BLUE_BOTTOM,
    BLUE_TOP,
    _four_glyphs,
    _hexagon_points,
    glass_highlight,
    h4_hex_four_glyphs,
    rounded_bg,
    soft_shadow,
    v_gradient,
    WHITE,
)

APP = os.path.normpath(
    os.path.join(os.path.dirname(os.path.abspath(__file__)), "..", "..", "app")
)


def render_full_bleed(size):
    """Opaque square icon (gradient bg, no rounded corners) for stores/launchers."""
    img = v_gradient((size, size), BLUE_TOP, BLUE_BOTTOM).convert("RGBA")
    img = glass_highlight(img)
    mark = Image.new("RGBA", img.size, (0, 0, 0, 0))
    h4_hex_four_glyphs(ImageDraw.Draw(mark), size / 2, size / 2, size)
    img = Image.alpha_composite(img, soft_shadow(mark))
    img = Image.alpha_composite(img, mark)
    return img.convert("RGB")


def render_rounded(size):
    """Rounded master icon (preview / legacy launchers)."""
    img = rounded_bg(size, BLUE_TOP, BLUE_BOTTOM)
    img = glass_highlight(img)
    mark = Image.new("RGBA", img.size, (0, 0, 0, 0))
    h4_hex_four_glyphs(ImageDraw.Draw(mark), size / 2, size / 2, size)
    img = Image.alpha_composite(img, soft_shadow(mark))
    img = Image.alpha_composite(img, mark)
    return img


def render_mark_transparent(size, mark_size):
    """White hexagon + blue glyphs on a transparent background (splash/foreground)."""
    img = Image.new("RGBA", (size, size), (0, 0, 0, 0))
    d = ImageDraw.Draw(img)
    d.polygon(_hexagon_points(size / 2, size / 2, mark_size * 0.44), fill=WHITE)
    _four_glyphs(d, size / 2, size / 2, mark_size, colored_tiles=False)
    shadow = soft_shadow(img)
    out = Image.new("RGBA", img.size, (0, 0, 0, 0))
    out.alpha_composite(shadow)
    out.alpha_composite(img)
    return out


def main():
    # -- master / splash ---------------------------------------------------
    rounded = render_rounded(1024)
    rounded.save(os.path.join(APP, "assets", "app_icon.png"))
    print("saved app/assets/app_icon.png")

    splash = render_mark_transparent(1024, 640)
    splash.save(os.path.join(APP, "assets", "splash", "splash_logo.png"))
    print("saved app/assets/splash/splash_logo.png")

    # -- Android legacy mipmaps -------------------------------------------
    legacy = {48: "mipmap-mdpi", 72: "mipmap-hdpi", 96: "mipmap-xhdpi",
              144: "mipmap-xxhdpi", 192: "mipmap-xxxhdpi"}
    for px, folder in legacy.items():
        render_full_bleed(px).save(
            os.path.join(APP, "android", "app", "src", "main", "res", folder, "ic_launcher.png")
        )
    print("saved android legacy mipmaps")

    # -- Android adaptive icon layers -------------------------------------
    fg = render_mark_transparent(1080, 720)
    fg.save(os.path.join(APP, "android", "app", "src", "main", "res",
                         "drawable", "ic_launcher_foreground.png"))
    bg = v_gradient((1080, 1080), BLUE_TOP, BLUE_BOTTOM).convert("RGB")
    bg.save(os.path.join(APP, "android", "app", "src", "main", "res",
                         "drawable", "ic_launcher_background.png"))
    print("saved android adaptive layers")

    # -- iOS icon set -------------------------------------------------------
    ios_dir = os.path.join(APP, "ios", "Runner", "Assets.xcassets",
                           "AppIcon.appiconset")
    sizes = {
        "Icon-App-20x20@1x.png": 20, "Icon-App-20x20@2x.png": 40,
        "Icon-App-20x20@3x.png": 60,
        "Icon-App-29x29@1x.png": 29, "Icon-App-29x29@2x.png": 58,
        "Icon-App-29x29@3x.png": 87,
        "Icon-App-40x40@1x.png": 40, "Icon-App-40x40@2x.png": 80,
        "Icon-App-40x40@3x.png": 120,
        "Icon-App-60x60@2x.png": 120, "Icon-App-60x60@3x.png": 180,
        "Icon-App-76x76@1x.png": 76, "Icon-App-76x76@2x.png": 152,
        "Icon-App-83.5x83.5@2x.png": 167,
        "Icon-App-1024x1024@1x.png": 1024,
    }
    for name, px in sizes.items():
        render_full_bleed(px).save(os.path.join(ios_dir, name))
    print("saved ios icon set")


if __name__ == "__main__":
    main()
