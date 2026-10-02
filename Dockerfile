# Stage 1 (best-effort): rasterize the SVG sources to PNG.
# Social networks ignore SVG og:image, and iOS wants a PNG touch icon.
# Every step may fail without failing the build, so a flaky package mirror
# never blocks a deploy; worst case the PNGs are missing and the SVGs still ship.
FROM alpine:3.20 AS raster
COPY assets/og.svg assets/apple-touch-icon.svg assets/favicon.svg /src/
RUN mkdir -p /out /usr/share/fonts/gbp \
 && { apk add --no-cache rsvg-convert font-liberation \
      || apk add --no-cache librsvg font-liberation \
      || true; } \
 && { apk add --no-cache font-inter || true; } \
 && for f in Regular Italic; do \
      wget -q -T 20 -O "/usr/share/fonts/gbp/InstrumentSerif-$f.ttf" \
        "https://raw.githubusercontent.com/google/fonts/main/ofl/instrumentserif/InstrumentSerif-$f.ttf" \
        || rm -f "/usr/share/fonts/gbp/InstrumentSerif-$f.ttf"; \
    done \
 && { fc-cache -f >/dev/null 2>&1 || true; } \
 && { rsvg-convert -w 1200 -h 630 /src/og.svg > /out/og.png || rm -f /out/og.png; } \
 && { rsvg-convert -w 180 -h 180 /src/apple-touch-icon.svg > /out/apple-touch-icon.png || rm -f /out/apple-touch-icon.png; } \
 && { rsvg-convert -w 32 -h 32 /src/favicon.svg > /out/favicon-32.png || rm -f /out/favicon-32.png; }

# Stage 2: static site on nginx.
FROM nginx:alpine
COPY index.html /usr/share/nginx/html/index.html
COPY assets/ /usr/share/nginx/html/assets/
COPY --from=raster /out/ /usr/share/nginx/html/assets/
EXPOSE 80
