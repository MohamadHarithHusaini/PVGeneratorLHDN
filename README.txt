PV GENERATOR — Offline App
===========================

TWO WAYS TO RUN
---------------
A) FULL FEATURES (recommended) — enables automatic amount reading
   from payment screenshots/PDFs:
     • Windows: double-click  "Start_PV_Generator (Windows).bat"
       Uses PowerShell, which is already built into Windows — no
       Python or any other install needed.
     • Mac/Linux: double-click "Start_PV_Generator (Mac-Linux).command"
       Uses Python 3, which most Macs already have installed.
   Opens the app at http://localhost:8000. Everything runs locally —
   no internet is used. Keep the window that opens running in the
   background — closing it stops the server.

B) QUICK — just double-click index.html
   Everything works except automatic amount reading; you type it
   yourself in that case.

Keep the "lib" folder next to index.html either way.

WHAT IT DOES
------------
Upload all your documents at once per line item (one drag-and-drop
style upload zone). Each file is auto-classified into:
   - Adjudication Letter*  — recognized from its content ("Nombor
     Adjudikasi" inside a PDF), or by filename if the PDF has no
     extractable text (scanned letters). The adjudication NUMBER and
     DUE DATE are both auto-read from the letter when possible.
   - Application*          — filename must contain "permohonan"
   - Purchase Order*       — filename contains "PO" + a number, or is
     mostly digits
   - Payment File*         — filename must contain "payment". The app
     finds the yellow-highlighted amount and OCRs just that region —
     works for both image screenshots AND PDF exports of the payment
     page (PDFs are rendered to an image first, then read the same way).
   - Additional Documents  — anything else, multiple files allowed,
     no filename rule enforced.
   * = mandatory. Due date is also mandatory and does NOT have an
       override — pick it manually if it wasn't auto-detected.

GENERATE — GROUPED BY DUE DATE
-------------------------------
Clicking Generate groups every item by its due date and produces ONE
ZIP file with one folder per due date:

    Payment_Vouchers - (Subsidiary).zip
      20-08-2026/
        PV.pdf
        PV - (Subsidiary) - Supporting Document (RM 57.00).pdf
        Adjudication_Numbers.txt
      25-08-2026/
        PV.pdf
        PV - (Subsidiary) - Supporting Document (RM 50.00).pdf
        Adjudication_Numbers.txt

Each folder contains:
  - PV.pdf — the 1-page voucher for that date's items
  - PV - (Subsidiary) - Supporting Document (RM total).pdf — index +
    separator pages + all supporting documents for that date's items
  - Adjudication_Numbers.txt — a plain-text list of every adjudication
    number (and its amount) included in that date's voucher

RULES & CHECKS
- Up to 50 line items (the Add button disables at 50).
- Name is mandatory — hard-blocks generation until entered (no
  override). Remembered between sessions once entered.
- Financial Year is mandatory — hard-blocks generation until entered
  (no override). Always starts blank; it is never remembered between
  sessions or defaulted to the current year, so it must be typed in
  every time.
- Business Unit (Subsidiary) is mandatory — hard-blocks generation
  until one is selected (no override). Preview PV does not need it.
- Due date is mandatory — hard-blocks generation until set (no override).
- Letter filename must contain the adjudication number.
- The 4 mandatory documents are required per line (warns, can override).
- Warns on amount-without-number or letter-without-amount.
- The same letter file can't be used on two lines.
- Duplicate adjudication numbers turn red.
- Any file with "(breakdown)" in its name is automatically excluded
  on upload — never classified, attached, or included in the ZIP.
  This applies everywhere files are uploaded, including PDF Page
  Swap below.

PV REFERENCE ID
Every voucher gets a short code, e.g. TSB-26-2108-60-01 (subsidiary
code — financial year — due date ddmm — total amount — batch number).
It appears as a small "Ref:" stamp at the bottom of the PV, in a banner on the supporting
documents' first page, and in the supporting-document file name.

CONVENIENCE
- "Preview PV" opens just the voucher page in a new tab (view only).
- Preparer name remembered between sessions.
- Save/Load draft (JSON, includes due dates). Re-attach files after
  loading a draft.

PV LAYOUT
- Times New Roman, size 11, throughout.
- Company value bold; Amount shown as "RM ###.##", bold; DR/CR totals
  bold; checkbox marks centered; consistent 1px grid lines; signature
  lines run right after each label with the name centered under it.


================================================================
TWO TOOLS IN ONE APP
================================================================
Use the floating round button on the right edge of the screen to
switch between:

  1. PV GENERATOR  — everything described above.
  2. PDF PAGE SWAP — Combine PDFs. Simply joins PDFs together; it
     does not read or change anything inside them.

     How to use it:
       a) Upload the signed PDF(s). A multi-page PDF is split
          automatically into one entry per page.
       b) Upload the supporting document PDF(s).
       c) Click any file (or its "🔍 View" button) to see it in the
          preview pane below the lists.
       d) Click "Combine & Download". Each signed page becomes one
          combined PDF: that page followed by all the supporting
          documents in full, in the order uploaded. One result
          downloads as a single PDF; several download as a ZIP.
     Use the x to remove a file. Files with "(breakdown)" in the
     name are skipped automatically.

INTERFACE NOTES
- Each adjudication line is a collapsible row. Collapsed, it shows
  the number, amount, due date and how many of the 4 required
  documents are attached — so 50 lines stay scannable.
  Use "Expand all" / "Collapse all" to switch in bulk.
- Name, Date and Subsidiary stay pinned at the top while you scroll,
  with the running total beside them.
- Save draft / Load draft / Preview PV / Generate ZIP are pinned in
  a bar at the bottom of the screen, always reachable.
- Document statuses are shown in a compact table per line, and the
  upload control is a single row instead of a large drop box.
