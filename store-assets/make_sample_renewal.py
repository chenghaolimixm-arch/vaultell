"""Create a fictional renewal notice for App Review testing."""

from pathlib import Path

from reportlab.lib import colors
from reportlab.lib.pagesizes import A4
from reportlab.lib.styles import ParagraphStyle, getSampleStyleSheet
from reportlab.lib.units import mm
from reportlab.platypus import (
    Paragraph,
    SimpleDocTemplate,
    Spacer,
    Table,
    TableStyle,
)

OUT = Path(__file__).resolve().parent / "sample-renewal-notice.pdf"


def main() -> None:
    styles = getSampleStyleSheet()
    title = ParagraphStyle(
        "title",
        parent=styles["Title"],
        fontName="Helvetica-Bold",
        fontSize=22,
        leading=26,
        textColor=colors.HexColor("#0B3D91"),
        spaceAfter=4,
    )
    subtitle = ParagraphStyle(
        "subtitle",
        parent=styles["Normal"],
        fontName="Helvetica-Bold",
        fontSize=13,
        leading=17,
        textColor=colors.HexColor("#1A2332"),
    )
    body = ParagraphStyle(
        "body",
        parent=styles["Normal"],
        fontName="Helvetica",
        fontSize=10.5,
        leading=15,
        textColor=colors.HexColor("#1A2332"),
    )
    note = ParagraphStyle(
        "note",
        parent=styles["Normal"],
        fontName="Helvetica-Oblique",
        fontSize=9,
        leading=13,
        textColor=colors.HexColor("#64748B"),
    )

    doc = SimpleDocTemplate(
        str(OUT),
        pagesize=A4,
        leftMargin=22 * mm,
        rightMargin=22 * mm,
        topMargin=20 * mm,
        bottomMargin=20 * mm,
        title="Sample Home Insurance Renewal Notice",
        author="Vaultell sample file",
    )

    story = [
        Paragraph("EXAMPLE INSURANCE AUSTRALIA", title),
        Paragraph("Home Insurance — Renewal Notice", subtitle),
        Spacer(1, 4 * mm),
        Paragraph(
            "<b>SAMPLE DOCUMENT — FOR APP REVIEW TESTING ONLY.</b> "
            "This insurer and all details are fictional.",
            note,
        ),
        Spacer(1, 7 * mm),
    ]

    rows = [
        ("Policy number", "POL-12345678"),
        ("Insured name", "Example Customer"),
        ("Property address", "12 Example Street, Brisbane QLD 4000"),
        ("Policy period", "20 May 2026 to 19 May 2027"),
        ("Cover type", "Comprehensive Home Insurance"),
        ("Total annual premium", "$1,850.00"),
        ("Excess", "$1,000.00"),
        ("Building insured", "$850,000.00"),
        ("Contents insured", "$35,000.00"),
        ("Status", "Active"),
    ]
    table = Table(
        [[Paragraph(f"<b>{label}</b>", body), Paragraph(value, body)] for label, value in rows],
        colWidths=[52 * mm, 95 * mm],
        hAlign="LEFT",
    )
    table.setStyle(
        TableStyle(
            [
                ("BACKGROUND", (0, 0), (-1, -1), colors.HexColor("#F3F3FA")),
                ("BOX", (0, 0), (-1, -1), 0.6, colors.HexColor("#CBD5E1")),
                ("INNERGRID", (0, 0), (-1, -1), 0.4, colors.HexColor("#E2E8F0")),
                ("VALIGN", (0, 0), (-1, -1), "MIDDLE"),
                ("LEFTPADDING", (0, 0), (-1, -1), 8),
                ("RIGHTPADDING", (0, 0), (-1, -1), 8),
                ("TOPPADDING", (0, 0), (-1, -1), 7),
                ("BOTTOMPADDING", (0, 0), (-1, -1), 7),
            ]
        )
    )
    story += [
        table,
        Spacer(1, 9 * mm),
        Paragraph(
            "This renewal notice is an example only. It does not relate to any real "
            "person, property or insurance policy.",
            note,
        ),
    ]
    doc.build(story)
    print(OUT)


if __name__ == "__main__":
    main()
