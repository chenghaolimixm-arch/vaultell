"""Compose App Store 6.9" screenshots (1320 x 2868) from raw iOS captures."""

from __future__ import annotations

from pathlib import Path

from PIL import Image, ImageDraw, ImageFilter, ImageFont

WIDTH, HEIGHT = 1320, 2868
SCREEN_W = 1040
SCREEN_H = round(SCREEN_W * HEIGHT / WIDTH)
SCREEN_X = (WIDTH - SCREEN_W) // 2
SCREEN_Y = 500
RADIUS = 52

SRC_DIR = Path(
    r"C:\Users\david\OneDrive\文档\xwechat_files\snookerlch_04fa\temp\RWTemp"
    r"\2026-10\9e20f478899dc29eb19741386f9343c8"
)
OUT_DIR = Path(__file__).resolve().parent / "app-store" / "screenshots"

BOLD_FONT = r"C:\Windows\Fonts\segoeuib.ttf"
REGULAR_FONT = r"C:\Windows\Fonts\segoeui.ttf"

SCREENS = [
    (
        "81f423edd6a0ffeae1bdcd979832c90c.png",
        "01-wallet.png",
        "All your insurance\nin one place",
        "Car, home, landlord and pet policies in one private wallet.",
    ),
    (
        "f2ec751c7aae87cac4b205d2bcf05764.png",
        "02-import.png",
        "Upload a policy —\nfields fill themselves",
        "Reads PDFs and images on your device.",
    ),
    (
        "fc47cc40c896e0106bfd920cfb3d8572.png",
        "03-policies.png",
        "Know every premium\nand renewal date",
        "All your policies, organised in one place.",
    ),
    (
        "70331d12e0d91fd28973ce0880bf83be.png",
        "04-comparison.png",
        "See what actually\nchanged",
        "Year-over-year premium and cover comparisons.",
    ),
    (
        "80a91908c184ca5fc9f2dfb38899d33c.png",
        "05-privacy.png",
        "Your data stays\non your device",
        "No account. No server. No tracking.",
    ),
]


def gradient_background() -> Image.Image:
    top = (11, 61, 145)
    bottom = (21, 101, 192)
    column = Image.new("RGB", (1, HEIGHT))
    for y in range(HEIGHT):
        t = y / (HEIGHT - 1)
        column.putpixel(
            (0, y),
            tuple(round(top[i] + (bottom[i] - top[i]) * t) for i in range(3)),
        )
    return column.resize((WIDTH, HEIGHT))


def draw_decor(canvas: Image.Image) -> Image.Image:
    layer = Image.new("RGBA", canvas.size, (0, 0, 0, 0))
    draw = ImageDraw.Draw(layer)
    draw.ellipse((-260, -320, 700, 560), fill=(255, 255, 255, 12))
    draw.ellipse((820, 250, 1560, 990), fill=(255, 255, 255, 9))
    draw.ellipse((900, 2380, 1600, 3080), fill=(255, 255, 255, 7))
    return Image.alpha_composite(canvas, layer)


def draw_centered(
    draw: ImageDraw.ImageDraw,
    text: str,
    font: ImageFont.FreeTypeFont,
    y: int,
    fill: tuple[int, int, int, int],
    line_gap: int = 0,
) -> int:
    for line in text.split("\n"):
        box = draw.textbbox((0, 0), line, font=font)
        x = (WIDTH - (box[2] - box[0])) // 2
        draw.text((x, y), line, font=font, fill=fill)
        y += (box[3] - box[1]) + line_gap
    return y


def wrap(
    draw: ImageDraw.ImageDraw,
    text: str,
    font: ImageFont.FreeTypeFont,
    max_width: int,
) -> str:
    words = text.split()
    lines: list[str] = []
    current = ""
    for word in words:
        candidate = f"{current} {word}".strip()
        if draw.textlength(candidate, font=font) <= max_width or not current:
            current = candidate
        else:
            lines.append(current)
            current = word
    if current:
        lines.append(current)
    return "\n".join(lines)


def compose(src: Path, dest: Path, headline: str, subline: str) -> None:
    canvas = gradient_background().convert("RGBA")
    canvas = draw_decor(canvas)
    draw = ImageDraw.Draw(canvas)

    wordmark_font = ImageFont.truetype(BOLD_FONT, 30)
    wordmark_box = draw.textbbox((0, 0), "V A U L T E L L", font=wordmark_font)
    draw.text(
        ((WIDTH - (wordmark_box[2] - wordmark_box[0])) // 2, 78),
        "V A U L T E L L",
        font=wordmark_font,
        fill=(255, 255, 255, 200),
    )

    headline_font = ImageFont.truetype(BOLD_FONT, 78)
    y = draw_centered(draw, headline, headline_font, 142, (255, 255, 255, 255), 6)

    sub_font = ImageFont.truetype(REGULAR_FONT, 38)
    draw_centered(
        draw,
        wrap(draw, subline, sub_font, 1140),
        sub_font,
        y + 18,
        (255, 255, 255, 235),
        6,
    )

    shot = Image.open(src).convert("RGB").resize((SCREEN_W, SCREEN_H), Image.Resampling.LANCZOS)
    mask = Image.new("L", shot.size, 0)
    ImageDraw.Draw(mask).rounded_rectangle(
        (0, 0, SCREEN_W - 1, SCREEN_H - 1), radius=RADIUS, fill=255
    )

    shadow = Image.new("RGBA", canvas.size, (0, 0, 0, 0))
    ImageDraw.Draw(shadow).rounded_rectangle(
        (SCREEN_X, SCREEN_Y + 20, SCREEN_X + SCREEN_W, SCREEN_Y + SCREEN_H + 20),
        radius=RADIUS,
        fill=(0, 0, 0, 120),
    )
    canvas = Image.alpha_composite(canvas, shadow.filter(ImageFilter.GaussianBlur(30)))
    canvas.paste(shot, (SCREEN_X, SCREEN_Y), mask)

    border = Image.new("RGBA", canvas.size, (0, 0, 0, 0))
    ImageDraw.Draw(border).rounded_rectangle(
        (SCREEN_X, SCREEN_Y, SCREEN_X + SCREEN_W, SCREEN_Y + SCREEN_H),
        radius=RADIUS,
        outline=(255, 255, 255, 70),
        width=3,
    )
    Image.alpha_composite(canvas, border).convert("RGB").save(dest, "PNG", optimize=True)


def montage(paths: list[Path], dest: Path) -> None:
    thumb_w = 264
    thumb_h = round(thumb_w * HEIGHT / WIDTH)
    gap = 24
    sheet = Image.new(
        "RGB",
        (thumb_w * len(paths) + gap * (len(paths) - 1), thumb_h),
        (245, 247, 250),
    )
    for index, path in enumerate(paths):
        thumb = Image.open(path).convert("RGB").resize(
            (thumb_w, thumb_h), Image.Resampling.LANCZOS
        )
        sheet.paste(thumb, (index * (thumb_w + gap), 0))
    sheet.save(dest, "PNG", optimize=True)


def main() -> None:
    OUT_DIR.mkdir(parents=True, exist_ok=True)
    outputs: list[Path] = []
    for name, out_name, headline, subline in SCREENS:
        dest = OUT_DIR / out_name
        compose(SRC_DIR / name, dest, headline, subline)
        outputs.append(dest)
        print(f"{dest.name}: {dest.stat().st_size // 1024} KB")
    preview = OUT_DIR.parent / "preview.png"
    montage(outputs, preview)
    print(f"preview: {preview}")


if __name__ == "__main__":
    main()
