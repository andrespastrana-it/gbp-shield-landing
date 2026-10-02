# GBP Shield landing (validation)
Static waitlist page for the 14-day experiment. Live: http://147.93.2.73:3080/ (Dokploy builds `Dockerfile` from `main`).

- `index.html` — the whole page (inline CSS/JS, Google Fonts: Instrument Serif + Inter).
- `assets/*.svg` — favicon, touch icon, and Open Graph image sources. The Docker build rasterizes them to `og.png`, `apple-touch-icon.png`, and `favicon-32.png` (best-effort; the build still succeeds if that step can't run).

## Waitlist capture
The form posts JSON to FormSubmit (`https://formsubmit.co/ajax/andreserluis@gmail.com`).
On the **first** submission FormSubmit emails an "Activate Form" link to that inbox; until it's clicked, submissions are rejected and the page shows its error state with a mailto fallback. Submit once yourself from the live site and click that link.
