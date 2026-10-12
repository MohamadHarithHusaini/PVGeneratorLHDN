#!/bin/bash
# ============================================================
#  PV Generator - one-click launcher (macOS / Linux)
#  Starts a local server so all features (incl. screenshot
#  amount reading) work. Everything stays on your computer;
#  no internet is used.
# ============================================================
cd "$(dirname "$0")"

echo "Starting PV Generator..."
echo

open_browser() {
  sleep 1
  if command -v open >/dev/null 2>&1; then open "http://localhost:8000/index.html"
  elif command -v xdg-open >/dev/null 2>&1; then xdg-open "http://localhost:8000/index.html"
  fi
}

if command -v python3 >/dev/null 2>&1; then
  open_browser &
  python3 -m http.server 8000
elif command -v python >/dev/null 2>&1; then
  open_browser &
  python -m http.server 8000
else
  echo "-------------------------------------------------------------"
  echo " Python was not found."
  echo
  echo " The app still works WITHOUT a server if you just open"
  echo " index.html in a browser - you will only need to type the"
  echo " payment amount yourself (automatic screenshot reading"
  echo " needs the server)."
  echo
  echo " To enable automatic amount reading, install Python 3 then"
  echo " run this launcher again."
  echo "-------------------------------------------------------------"
  read -p "Press Enter to close..."
fi
