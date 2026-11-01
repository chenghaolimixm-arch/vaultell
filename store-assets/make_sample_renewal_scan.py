"""Create a scanned-style, high-contrast sample renewal notice."""

from pathlib import Path

from PIL import Image, ImageDraw, ImageFont

OUT_DIR = Path(__file__).resolve().parent
PNG = OUT_DIR / "sample-renewal-notice-scan.png"
PDF = OUT_DIR / "sample-renewal-notice.pdf"

BOLD = r"C:\Windows\Fonts\segoeuib.ttf"
REGULAR = r"C:\Windows\Fonts\segoeui.ttf"

W, H = 2550, 3300
BLACK = (17, 17, 17)
BLUE = (11, 61, 145)
GRAY = (80, 80, 80)

ROWS = [
    ("Policy Number", "POL-12345678"),
    ("Insured Name", "Example Customer"),
    ("Property Address", "12 Example Street, Brisbane QLD 4000"),
    ("Policy Period", "20 May 2026 to 19 May 2027"),
    ("Cover Type", "Comprehensive Home Insurance"),
    ("Total Annual Premium", "$1,850.00"),
    ("Excess", "$1,000.00"),
    ("Building Insured", "$850,000.00"),
    ("Contents Insured", "$35,000.00"),
    ("Status", "Active"),
]


def main() -> None:
    image = Image.new("RGB", (W, H), "white")
    draw = ImageDraw.Draw(image)

    draw.text((160, 150), "EXAMPLE INSURANCE AUSTRALIA", font=ImageFont.truetype(BOLD, 82), fill=BLUE)
    draw.text((160, 270), "HOME INSURANCE — RENEWAL NOTICE", font=ImageFont.truetype(BOLD, 58), fill=BLACK)
    draw.text(
        (160, 360),
        "SAMPLE DOCUMENT — FOR APP REVIEW TESTING ONLY. All details are fictional.",
        font=ImageFont.truetype(REGULAR, 36),
        fill=GRAY,
    )

    label_font = ImageFont.truetype(BOLD, 52)
    value_font = ImageFont.truetype(REGULAR, 52)
    y = 560
    for index, (label, value) in enumerate(ROWS):
        if index:
            draw.line((160, y - 24, W - 160, y - 24), fill=(200, 200, 200), width=2)
        prefix = f"{label}: "
        draw.text((160, y), prefix, font=label_font, fill=BLACK)
        offset = draw.textlength(prefix, font=label_font)
        draw.text((160 + offset, y), value, font=value_font, fill=BLACK)
        y += 150

    draw.text(
        (160, H - 300),
        "This renewal notice is an example only. It does not relate to any real person,",
        font=ImageFont.truetype(REGULAR, 34),
        fill=GRAY,
    )
    draw.text(
        (160, H - 245),
        "property or insurance policy.",
        font=ImageFont.truetype(REGULAR, 34),
        fill=GRAY,
    )

    image.save(PNG, "PNG")
    image.save(PDF, "PDF", resolution=300.0)
    print(PNG)
    print(PDF)


if __name__ == "__main__":
    main()
