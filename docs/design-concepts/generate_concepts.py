"""Generate concept mockups for the Vaultell app icon and launch screen.

Run:  python generate_concepts.py
Outputs PNG files in the same folder (for design review, not final assets).
Icons are drawn at 4x and downscaled for smooth edges.
"""

import os
from PIL import Image, ImageDraw, ImageFilter, ImageFont

OUT = os.path.dirname(os.path.abspath(__file__))

BLUE_TOP = (33, 125, 215, 255)      # lighter blue
BLUE_BOTTOM = (13, 71, 161, 255)    # #0D47A1
TEAL_TOP = (0, 172, 193, 255)
TEAL_BOTTOM = (0, 105, 122, 255)
WHITE = (255, 255, 255, 255)
GREEN = (67, 160, 71, 255)          # #43A047

FONT_TITLE = "C:/Windows/Fonts/arialbd.ttf"
FONT_BODY = "C:/Windows/Fonts/arial.ttf"


# ---------------------------------------------------------------- helpers

def v_gradient(size, top, bottom):
    """Vertical gradient image (top color -> bottom color)."""
    top_img = Image.new("RGB", size, top)
    bottom_img = Image.new("RGB", size, bottom)
    mask = Image.linear_gradient("L").resize(size)
    return Image.composite(bottom_img, top_img, mask)


def rounded_bg(size, top, bottom, radius_ratio=0.225):
    """Rounded-square background with a vertical gradient."""
    size = (size, size)
    bg = v_gradient(size, top, bottom)
    mask = Image.new("L", size, 0)
    md = ImageDraw.Draw(mask)
    md.rounded_rectangle([0, 0, size[0] - 1, size[1] - 1],
                         radius=int(size[0] * radius_ratio), fill=255)
    out = Image.new("RGBA", size, (0, 0, 0, 0))
    out.paste(bg, (0, 0), mask)
    return out


def glass_highlight(img):
    """Subtle translucent highlight in the top-left corner."""
    S = img.size[0]
    layer = Image.new("RGBA", img.size, (0, 0, 0, 0))
    d = ImageDraw.Draw(layer)
    d.ellipse([-S * 0.12, -S * 0.22, S * 0.62, S * 0.30], fill=(255, 255, 255, 26))
    layer = layer.filter(ImageFilter.GaussianBlur(S * 0.02))
    return Image.alpha_composite(img, layer)


def soft_shadow(mark, blur_ratio=0.028, dy_ratio=0.018):
    """Return a blurred black shadow layer matching the mark silhouette."""
    S = mark.size[0]
    shadow = Image.new("RGBA", mark.size, (0, 0, 0, 0))
    shadow.paste((10, 20, 40, 110), (0, 0), mark)
    shadow = shadow.filter(ImageFilter.GaussianBlur(S * blur_ratio))
    out = Image.new("RGBA", mark.size, (0, 0, 0, 0))
    out.alpha_composite(shadow, (0, int(S * dy_ratio)))
    return out


def rounded_check(draw, cx, cy, size, color, width_ratio=0.062):
    """Bold rounded checkmark centered around (cx, cy)."""
    w = max(4, int(size * width_ratio))
    draw.line(
        [(cx - size * 0.155, cy + size * 0.005),
         (cx - size * 0.045, cy + size * 0.115),
         (cx + size * 0.165, cy - size * 0.135)],
        fill=color, width=w, joint="curve",
    )
    r = w / 2
    for (x, y) in [(cx - size * 0.155, cy + size * 0.005),
                   (cx + size * 0.165, cy - size * 0.135)]:
        draw.ellipse([x - r, y - r, x + r, y + r], fill=color)


def scalloped_bottom(draw, cx, cy, width, color):
    """Even row of semicircle bumps forming an umbrella scallop edge."""
    n = 6
    r = width / (n * 2)
    for i in range(n):
        x = cx - width / 2 + r * (i * 2 + 1)
        draw.pieslice([x - r, cy - r, x + r, cy + r], 180, 360, fill=color)


def umbrella_handle(draw, cx, top_y, bottom_y, color, size, tip=True):
    """Vertical stem + J-curve handle with rounded caps and optional finial."""
    lw = max(4, int(size * 0.052))
    draw.line([(cx, top_y), (cx, bottom_y)], fill=color, width=lw)
    r = lw / 2
    draw.ellipse([cx - r, top_y - r, cx + r, top_y + r], fill=color)
    draw.arc([cx - size * 0.17, bottom_y - size * 0.06,
              cx + size * 0.17, bottom_y + size * 0.22],
             0, 180, fill=color, width=lw)
    draw.ellipse([cx + size * 0.17 - r, bottom_y + size * 0.08 - r,
                  cx + size * 0.17 + r, bottom_y + size * 0.08 + r], fill=color)
    if tip:
        tr = size * 0.022
        draw.ellipse([cx - tr, top_y - size * 0.10 - tr,
                      cx + tr, top_y - size * 0.10 + tr], fill=color)


# ---------------------------------------------------------------- concepts

def ab1_shield_umbrella(draw, cx, cy, size):
    """Fusion A+B #1: shield-shaped umbrella canopy + checkmark."""
    top = cy - size * 0.30
    w = size * 0.72
    left, right = cx - w / 2, cx + w / 2
    pts = [
        (cx, top - size * 0.015),
        (right, top + size * 0.06),
        (right, top + size * 0.20),
        (right - w * 0.10, top + size * 0.30),
        (right - w * 0.10, top + size * 0.34),
        (left + w * 0.10, top + size * 0.34),
        (left + w * 0.10, top + size * 0.30),
        (left, top + size * 0.20),
        (left, top + size * 0.06),
    ]
    draw.polygon(pts, fill=WHITE)
    scalloped_bottom(draw, cx, top + size * 0.315, w, WHITE)
    umbrella_handle(draw, cx, top + size * 0.34, cy + size * 0.30, WHITE, size)
    rounded_check(draw, cx, top + size * 0.17, size, GREEN)


def ab2_umbrella_pendant_shield(draw, cx, cy, size):
    """Fusion A+B #2: umbrella canopy on top, shield pendant hanging below."""
    top = cy - size * 0.34
    w = size * 0.72
    r = w / 2
    draw.pieslice([cx - r, top - size * 0.05, cx + r, top + r * 1.10], 180, 360, fill=WHITE)
    scalloped_bottom(draw, cx, top + size * 0.10, w, WHITE)
    tr = size * 0.022
    draw.ellipse([cx - tr, top - size * 0.14 - tr, cx + tr, top - size * 0.14 + tr], fill=WHITE)
    lw = max(4, int(size * 0.045))
    draw.line([(cx, top + size * 0.10), (cx, cy + size * 0.06)], fill=WHITE, width=lw)
    sy = cy + size * 0.22
    sh = size * 0.36
    pts = [
        (cx - size * 0.19, sy - sh / 2),
        (cx + size * 0.19, sy - sh / 2),
        (cx + size * 0.19, sy - sh * 0.10),
        (cx, sy + sh / 2),
        (cx - size * 0.19, sy - sh * 0.10),
    ]
    draw.polygon(pts, fill=WHITE)
    rounded_check(draw, cx, sy, size * 0.62, GREEN)


def ab3_check_umbrella(draw, cx, cy, size):
    """Fusion A+B #3: clean umbrella with a bold checkmark on the canopy."""
    top = cy - size * 0.32
    r = size * 0.46
    draw.pieslice([cx - r, top - size * 0.08, cx + r, top + r * 1.10], 180, 360, fill=WHITE)
    scalloped_bottom(draw, cx, top + size * 0.12, r * 2, WHITE)
    umbrella_handle(draw, cx, top + size * 0.12, cy + size * 0.32, WHITE, size)
    rounded_check(draw, cx, top + size * 0.14, size * 0.92, GREEN)


def wc1_wallet_cards(draw, cx, cy, size):
    """Wallet holding several policy cards — everything in one place."""
    # back card (teal)
    draw.rounded_rectangle(
        [cx - size * 0.20, cy - size * 0.46, cx + size * 0.20, cy - size * 0.12],
        radius=size * 0.045, fill=(0, 131, 143, 255),
    )
    # front card (blue)
    draw.rounded_rectangle(
        [cx - size * 0.20, cy - size * 0.40, cx + size * 0.20, cy - size * 0.06],
        radius=size * 0.045, fill=(30, 136, 229, 255),
    )
    # wallet body over the cards
    w = size * 0.66
    draw.rounded_rectangle(
        [cx - w / 2, cy - size * 0.12, cx + w / 2, cy + size * 0.34],
        radius=size * 0.095, fill=WHITE,
    )
    # clasp
    cw = size * 0.20
    draw.rounded_rectangle(
        [cx - cw / 2, cy - size * 0.105, cx + cw / 2, cy - size * 0.055],
        radius=size * 0.025, fill=(144, 202, 249, 255),
    )
    # subtle card stripes on the wallet
    for i, yy in enumerate([0.10, 0.17, 0.24]):
        draw.rounded_rectangle(
            [cx - w * 0.34, cy + yy * size, cx - w * 0.02, cy + (yy + 0.035) * size],
            radius=size * 0.012, fill=(224, 236, 250, 255),
        )


def wc2_fanned_cards(draw, cx, cy, size):
    """Three fanned policy cards — a hand of policies in one place."""
    S = size
    cards = [
        (-16, (144, 202, 249, 255)),   # light blue, back
        (0, (255, 255, 255, 255)),     # white, middle
        (16, (0, 131, 143, 255)),      # teal, front
    ]
    for angle, color in cards:
        card = Image.new("RGBA", (S, S), (0, 0, 0, 0))
        d = ImageDraw.Draw(card)
        w, h = size * 0.38, size * 0.54
        left, top = S / 2 - w / 2, S * 0.34 - h / 2
        d.rounded_rectangle([left, top, left + w, top + h],
                            radius=size * 0.045, fill=color)
        rotated = card.rotate(angle, resample=Image.BICUBIC,
                              center=(S / 2, S * 0.56))
        draw._image.paste(rotated, (0, 0), rotated)


def wc3_stacked_house(draw, cx, cy, size):
    """Stacked cards with a house on top — home base for all policies."""
    # back card (teal)
    draw.rounded_rectangle(
        [cx - size * 0.17, cy - size * 0.34, cx + size * 0.17, cy + size * 0.20],
        radius=size * 0.045, fill=(0, 131, 143, 255),
    )
    # middle card (blue)
    draw.rounded_rectangle(
        [cx - size * 0.17, cy - size * 0.28, cx + size * 0.17, cy + size * 0.26],
        radius=size * 0.045, fill=(30, 136, 229, 255),
    )
    # top card (white) with house
    draw.rounded_rectangle(
        [cx - size * 0.17, cy - size * 0.22, cx + size * 0.17, cy + size * 0.32],
        radius=size * 0.045, fill=WHITE,
    )
    hs = size * 0.26
    hy = cy - size * 0.02
    # roof
    draw.polygon(
        [(cx - hs * 0.24, hy - hs * 0.02),
         (cx + hs * 0.24, hy - hs * 0.02),
         (cx, hy - hs * 0.26)],
        fill=(30, 136, 229, 255),
    )
    # body
    draw.rounded_rectangle(
        [cx - hs * 0.15, hy - hs * 0.02, cx + hs * 0.15, hy + hs * 0.20],
        radius=hs * 0.04, fill=(30, 136, 229, 255),
    )


def _house_glyph(draw, cx, cy, s, color):
    """Minimal house: roof triangle + body."""
    draw.polygon(
        [(cx - s * 0.24, cy - s * 0.02),
         (cx + s * 0.24, cy - s * 0.02),
         (cx, cy - s * 0.26)],
        fill=color,
    )
    draw.rounded_rectangle(
        [cx - s * 0.15, cy - s * 0.02, cx + s * 0.15, cy + s * 0.20],
        radius=s * 0.04, fill=color,
    )


def m1_house_card(draw, cx, cy, size):
    """Modern #1: white policy card + blue roof + door, teal card peeking."""
    # peeking card (teal)
    draw.rounded_rectangle(
        [cx - size * 0.215, cy - size * 0.30, cx + size * 0.215, cy + size * 0.22],
        radius=size * 0.055, fill=(0, 131, 143, 255),
    )
    # roof
    draw.polygon(
        [(cx - size * 0.205, cy - size * 0.25),
         (cx + size * 0.205, cy - size * 0.25),
         (cx, cy - size * 0.48)],
        fill=(30, 136, 229, 255),
    )
    # card body (white)
    draw.rounded_rectangle(
        [cx - size * 0.205, cy - size * 0.25, cx + size * 0.205, cy + size * 0.25],
        radius=size * 0.06, fill=WHITE,
    )
    # door
    dw = size * 0.075
    draw.rounded_rectangle(
        [cx - dw / 2, cy + size * 0.10, cx + dw / 2, cy + size * 0.25],
        radius=dw / 2, fill=(30, 136, 229, 255),
    )
    # card slot lines
    for i in range(2):
        y = cy - size * 0.12 + i * size * 0.075
        draw.rounded_rectangle(
            [cx - size * 0.155, y, cx - size * 0.015, y + size * 0.032],
            radius=size * 0.012, fill=(224, 236, 250, 255),
        )


def m2_hexagon_card(draw, cx, cy, size):
    """Modern #2: hexagon container with a card + house glyph inside."""
    r = size * 0.46
    pts = []
    for i in range(6):
        ang = -90 + i * 60
        import math
        pts.append((cx + r * math.cos(math.radians(ang)),
                    cy + r * math.sin(math.radians(ang))))
    draw.polygon(pts, fill=(100, 181, 246, 255))  # light blue hexagon
    # card
    draw.rounded_rectangle(
        [cx - size * 0.195, cy - size * 0.10, cx + size * 0.195, cy + size * 0.30],
        radius=size * 0.055, fill=WHITE,
    )
    _house_glyph(draw, cx, cy + size * 0.10, size * 0.30, (30, 136, 229, 255))


def m3_house_card_solid(draw, cx, cy, size):
    """Modern #3: single house-shaped card (roof + card as one silhouette)."""
    # peeking card (light blue)
    draw.rounded_rectangle(
        [cx - size * 0.215, cy - size * 0.24, cx + size * 0.215, cy + size * 0.30],
        radius=size * 0.06, fill=(144, 202, 249, 255),
    )
    # white roof + card as one silhouette
    draw.polygon(
        [(cx - size * 0.205, cy - size * 0.20),
         (cx + size * 0.205, cy - size * 0.20),
         (cx, cy - size * 0.45)],
        fill=WHITE,
    )
    draw.rounded_rectangle(
        [cx - size * 0.205, cy - size * 0.20, cx + size * 0.205, cy + size * 0.28],
        radius=size * 0.06, fill=WHITE,
    )
    # blue door
    dw = size * 0.08
    draw.rounded_rectangle(
        [cx - dw / 2, cy + size * 0.12, cx + dw / 2, cy + size * 0.28],
        radius=dw / 2, fill=(30, 136, 229, 255),
    )


def _hexagon_points(cx, cy, r):
    import math
    pts = []
    for i in range(6):
        ang = -90 + i * 60
        pts.append((cx + r * math.cos(math.radians(ang)),
                    cy + r * math.sin(math.radians(ang))))
    return pts


def _house_card_glyph(draw, cx, cy, s, color):
    """House and card as one silhouette: roof + rounded card body."""
    draw.polygon(
        [(cx - s * 0.24, cy - s * 0.14),
         (cx + s * 0.24, cy - s * 0.14),
         (cx, cy - s * 0.38)],
        fill=color,
    )
    draw.rounded_rectangle(
        [cx - s * 0.24, cy - s * 0.14, cx + s * 0.24, cy + s * 0.22],
        radius=s * 0.07, fill=color,
    )


def h1_hex_house(draw, cx, cy, size):
    """Hexagon + minimal house glyph (white hexagon, blue house)."""
    draw.polygon(_hexagon_points(cx, cy, size * 0.44), fill=WHITE)
    _house_glyph(draw, cx, cy + size * 0.01, size * 0.30, (30, 136, 229, 255))


def h2_hex_house_card(draw, cx, cy, size):
    """Hexagon + house-card silhouette (white hexagon, blue mark)."""
    draw.polygon(_hexagon_points(cx, cy, size * 0.44), fill=WHITE)
    _house_card_glyph(draw, cx, cy + size * 0.02, size * 0.28, (30, 136, 229, 255))


def h3_hex_white_house(draw, cx, cy, size):
    """Light-blue hexagon + white minimal house glyph."""
    draw.polygon(_hexagon_points(cx, cy, size * 0.44), fill=(144, 202, 249, 255))
    _house_glyph(draw, cx, cy + size * 0.01, size * 0.30, WHITE)


def _glyph_house(draw, cx, cy, s, color):
    """Strong house: tall roof + solid body."""
    draw.polygon(
        [(cx - s * 0.28, cy - s * 0.06),
         (cx + s * 0.28, cy - s * 0.06),
         (cx, cy - s * 0.38)],
        fill=color,
    )
    draw.rounded_rectangle(
        [cx - s * 0.20, cy - s * 0.06, cx + s * 0.20, cy + s * 0.32],
        radius=s * 0.06, fill=color,
    )


def _glyph_car(draw, cx, cy, s, color):
    """Strong car: cabin + body + wheels."""
    draw.rounded_rectangle(
        [cx - s * 0.105, cy - s * 0.28, cx + s * 0.105, cy - s * 0.07],
        radius=s * 0.05, fill=color,
    )
    draw.rounded_rectangle(
        [cx - s * 0.30, cy - s * 0.13, cx + s * 0.30, cy + s * 0.09],
        radius=s * 0.07, fill=color,
    )
    r = s * 0.075
    for x in (cx - s * 0.155, cx + s * 0.155):
        draw.ellipse([x - r, cy + s * 0.05, x + r, cy + s * 0.05 + 2 * r], fill=color)


def _glyph_paw(draw, cx, cy, s, color):
    """Soft round paw: plump pad + toes in a gentle arc."""
    draw.ellipse(
        [cx - s * 0.135, cy - s * 0.055, cx + s * 0.135, cy + s * 0.195],
        fill=color,
    )
    r = s * 0.078
    for dx, dy in [(-0.145, -0.115), (0.0, -0.165), (0.145, -0.115)]:
        draw.ellipse([cx + dx * s - r, cy + dy * s - r,
                      cx + dx * s + r, cy + dy * s + r], fill=color)


def _glyph_heart(draw, cx, cy, s, color):
    """Strong heart: two lobes + pointed base."""
    r = s * 0.11
    for dx in (-1.05, 1.05):
        draw.ellipse([cx + dx * r - r, cy - r - s * 0.03,
                      cx + dx * r + r, cy + r - s * 0.03], fill=color)
    draw.polygon(
        [(cx - r * 1.95, cy - s * 0.005),
         (cx + r * 1.95, cy - s * 0.005),
         (cx, cy + r * 1.75)],
        fill=color,
    )


def _four_glyphs(draw, cx, cy, size, colored_tiles):
    """2x2 grid of four insurance-type glyphs inside the hexagon."""
    colors = {
        "home": (46, 125, 50, 255),      # green
        "car": (21, 101, 192, 255),      # blue
        "pet": (239, 108, 0, 255),       # orange
        "health": (198, 40, 40, 255),    # red
    }
    glyphs = {
        "home": _glyph_house,
        "car": _glyph_car,
        "pet": _glyph_paw,
        "health": _glyph_heart,
    }
    order = [("home", -1, -1), ("car", 1, -1), ("pet", -1, 1), ("health", 1, 1)]
    tile = size * 0.175
    for key, gx, gy in order:
        tcx = cx + gx * size * 0.105
        tcy = cy + gy * size * 0.105
        if colored_tiles:
            draw.rounded_rectangle(
                [tcx - tile / 2, tcy - tile / 2, tcx + tile / 2, tcy + tile / 2],
                radius=tile * 0.24, fill=colors[key],
            )
            glyphs[key](draw, tcx, tcy, tile * 0.72, WHITE)
        else:
            glyphs[key](draw, tcx, tcy, tile * 0.92, (21, 101, 192, 255))


def h4_hex_four_glyphs(draw, cx, cy, size):
    """White hexagon + four blue glyphs (house/car/paw/heart)."""
    draw.polygon(_hexagon_points(cx, cy, size * 0.44), fill=WHITE)
    _four_glyphs(draw, cx, cy, size, colored_tiles=False)


def h5_hex_four_tiles(draw, cx, cy, size):
    """White hexagon + four colored tiles with white glyphs."""
    draw.polygon(_hexagon_points(cx, cy, size * 0.44), fill=WHITE)
    _four_glyphs(draw, cx, cy, size, colored_tiles=True)


def h6_hex_four_dots(draw, cx, cy, size):
    """White hexagon + four colored dots (one per insurance type)."""
    draw.polygon(_hexagon_points(cx, cy, size * 0.44), fill=WHITE)
    colors = [(46, 125, 50, 255), (21, 101, 192, 255),
              (239, 108, 0, 255), (198, 40, 40, 255)]
    pos = [(-1, -1), (1, -1), (-1, 1), (1, 1)]
    r = size * 0.075
    for (gx, gy), color in zip(pos, colors):
        draw.ellipse([cx + gx * size * 0.105 - r, cy + gy * size * 0.105 - r,
                      cx + gx * size * 0.105 + r, cy + gy * size * 0.105 + r],
                     fill=color)


def h4c_hex_four_colors(draw, cx, cy, size):
    """White hexagon + four theme-colored glyphs (green/blue/orange/red)."""
    draw.polygon(_hexagon_points(cx, cy, size * 0.44), fill=WHITE)
    colors = [(46, 125, 50, 255), (21, 101, 192, 255),
              (239, 108, 0, 255), (198, 40, 40, 255)]
    glyphs = [_glyph_house, _glyph_car, _glyph_paw, _glyph_heart]
    pos = [(-1, -1), (1, -1), (-1, 1), (1, 1)]
    tile = size * 0.175
    for (gx, gy), color, glyph in zip(pos, colors, glyphs):
        tcx = cx + gx * size * 0.105
        tcy = cy + gy * size * 0.105
        glyph(draw, tcx, tcy, tile * 0.92, color)


def render_icon(painter, top, bottom, size=4096, out_size=1024):
    img = rounded_bg(size, top, bottom)
    img = glass_highlight(img)
    mark = Image.new("RGBA", img.size, (0, 0, 0, 0))
    painter(ImageDraw.Draw(mark), size / 2, size / 2, size)
    img = Image.alpha_composite(img, soft_shadow(mark))
    img = Image.alpha_composite(img, mark)
    return img.resize((out_size, out_size), Image.LANCZOS)


def make_icon(name, painter, top, bottom):
    img = render_icon(painter, top, bottom)
    img.save(os.path.join(OUT, name))
    print("saved", name)


def make_legibility_sheet():
    """Show the H4 icon at real-world sizes to check legibility."""
    icon = render_icon(h4_hex_four_glyphs, BLUE_TOP, BLUE_BOTTOM)
    W, H = 1700, 1150
    sheet = Image.new("RGB", (W, H), (16, 28, 46, 255))
    d = ImageDraw.Draw(sheet)
    title = ImageFont.truetype(FONT_TITLE, 46)
    label_font = ImageFont.truetype(FONT_BODY, 30)
    d.text((40, 28), "H4 legibility check", font=title, fill=WHITE)
    # big render
    big = icon.resize((760, 760), Image.LANCZOS)
    sheet.paste(big, (120, 130))
    # small renders
    sizes = [144, 96, 64, 48, 32]
    total = sum(sizes) + 40 * (len(sizes) - 1)
    x = (W - total) // 2
    y = 980
    for s in sizes:
        small = icon.resize((s, s), Image.LANCZOS)
        sheet.paste(small, (x, y))
        label = f"{s}px"
        lw = d.textlength(label, font=label_font)
        d.text((x + (s - lw) / 2, y + s + 12), label, font=label_font, fill=(190, 205, 225, 255))
        x += s + 40
    sheet.save(os.path.join(OUT, "icon_legibility_sheet.png"))
    print("saved icon_legibility_sheet.png")


def make_launch():
    W, H = 1200, 2400
    bg = v_gradient((W, H), BLUE_TOP, BLUE_BOTTOM)
    img = bg.convert("RGBA")
    glow = Image.new("RGBA", img.size, (0, 0, 0, 0))
    gd = ImageDraw.Draw(glow)
    gd.ellipse([W / 2 - 360, 600, W / 2 + 360, 1320], fill=(255, 255, 255, 26))
    glow = glow.filter(ImageFilter.GaussianBlur(60))
    img = Image.alpha_composite(img, glow)

    mark = Image.new("RGBA", (W, H), (0, 0, 0, 0))
    ab1_shield_umbrella(ImageDraw.Draw(mark), W / 2, 940, 320)
    img = Image.alpha_composite(img, soft_shadow(mark))
    img = Image.alpha_composite(img, mark)
    d = ImageDraw.Draw(img)

    title = ImageFont.truetype(FONT_TITLE, 72)
    body = ImageFont.truetype(FONT_BODY, 40)
    name = "Vaultell"
    tag = "Your policies. On your device."
    nw = d.textlength(name, font=title)
    tw = d.textlength(tag, font=body)
    d.text(((W - nw) / 2, 1280), name, font=title, fill=WHITE)
    d.text(((W - tw) / 2, 1400), tag, font=body, fill=(216, 230, 245, 255))
    img.convert("RGB").save(os.path.join(OUT, "launch_screen.png"))
    print("saved launch_screen.png")


if __name__ == "__main__":
    make_icon("icon_concept_ab1_shield_umbrella.png", ab1_shield_umbrella, BLUE_TOP, BLUE_BOTTOM)
    make_icon("icon_concept_ab2_umbrella_shield.png", ab2_umbrella_pendant_shield, BLUE_TOP, BLUE_BOTTOM)
    make_icon("icon_concept_ab3_check_umbrella.png", ab3_check_umbrella, TEAL_TOP, TEAL_BOTTOM)
    make_icon("icon_concept_wc1_wallet_cards.png", wc1_wallet_cards, BLUE_TOP, BLUE_BOTTOM)
    make_icon("icon_concept_wc2_fanned_cards.png", wc2_fanned_cards, BLUE_TOP, BLUE_BOTTOM)
    make_icon("icon_concept_wc3_stacked_house.png", wc3_stacked_house, BLUE_TOP, BLUE_BOTTOM)
    make_icon("icon_concept_m1_house_card.png", m1_house_card, BLUE_TOP, BLUE_BOTTOM)
    make_icon("icon_concept_m2_hexagon_card.png", m2_hexagon_card, BLUE_TOP, BLUE_BOTTOM)
    make_icon("icon_concept_m3_house_card_solid.png", m3_house_card_solid, BLUE_TOP, BLUE_BOTTOM)
    make_icon("icon_concept_h1_hex_house.png", h1_hex_house, BLUE_TOP, BLUE_BOTTOM)
    make_icon("icon_concept_h2_hex_house_card.png", h2_hex_house_card, BLUE_TOP, BLUE_BOTTOM)
    make_icon("icon_concept_h3_hex_white_house.png", h3_hex_white_house, BLUE_TOP, BLUE_BOTTOM)
    make_icon("icon_concept_h4_hex_four_glyphs.png", h4_hex_four_glyphs, BLUE_TOP, BLUE_BOTTOM)
    make_icon("icon_concept_h4c_hex_four_colors.png", h4c_hex_four_colors, BLUE_TOP, BLUE_BOTTOM)
    make_icon("icon_concept_h5_hex_four_tiles.png", h5_hex_four_tiles, BLUE_TOP, BLUE_BOTTOM)
    make_icon("icon_concept_h6_hex_four_dots.png", h6_hex_four_dots, BLUE_TOP, BLUE_BOTTOM)
    make_legibility_sheet()
    make_launch()
