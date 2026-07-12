#!/usr/bin/env python3
"""Top-down PNG (RGB + fake checkerboard) → RGBA с настоящим alpha."""

from __future__ import annotations

import subprocess
import sys
from collections import deque
from pathlib import Path

from PIL import Image

ROOT = Path(__file__).resolve().parents[2]
ART_REV = "8b7e51f"

NEW_SPRITES = [
    "expansion_app/assets/images/bases/base1.png",
    "expansion_app/assets/images/bases/base2.png",
    "expansion_app/assets/images/bases/base3.png",
    "expansion_app/assets/images/bases/base_small.png",
    "expansion_app/assets/images/bases/base_medium.png",
    "expansion_app/assets/images/bases/base_large.png",
    "expansion_app/assets/images/bases/base_rich.png",
    "expansion_app/assets/images/bases/base_shielded.png",
    "expansion_app/assets/images/bases/base_factory.png",
    "expansion_app/assets/images/bases/base_bunker.png",
    "expansion_app/assets/images/our.png",
    "expansion_app/assets/images/enemy.png",
    "expansion_app/assets/images/hq_player.png",
    "expansion_app/assets/images/hq_enemy.png",
    "expansion_app/assets/images/asteroids/ast1.png",
    "expansion_app/assets/images/asteroids/ast2.png",
    "expansion_app/assets/images/asteroids/ast3.png",
    "expansion_app/assets/images/asteroids/ast4.png",
    "expansion_app/assets/images/asteroids/ast5.png",
    "expansion_app/assets/images/asteroids/ast6.png",
    "expansion_app/assets/images/hazards/asteroid.png",
    "expansion_app/assets/images/hazards/comet.png",
    "expansion_app/assets/images/hazards/debris_cloud.png",
    "expansion_app/assets/images/hazards/energy_pulse.png",
    "expansion_app/assets/images/hazards/mine.png",
    "expansion_app/assets/images/hazards/rogue_drone.png",
    "expansion_app/assets/images/hazards/solar_wind.png",
    "expansion_app/assets/images/hazards/wormhole.png",
]

# Нейтральный светлый фон / «шахматка» генератора.
MIN_NEUTRAL = 175
MAX_CHROMA = 32


def is_background_pixel(r: int, g: int, b: int) -> bool:
    mn = min(r, g, b)
    mx = max(r, g, b)
    if mn >= 248:
        return True
    return mn >= MIN_NEUTRAL and (mx - mn) <= MAX_CHROMA


def flood_transparent(img: Image.Image) -> Image.Image:
    rgba = img.convert("RGBA")
    w, h = rgba.size
    pixels = rgba.load()
    transparent = [[False] * w for _ in range(h)]

    def try_mark(x: int, y: int) -> None:
        if x < 0 or x >= w or y < 0 or y >= h or transparent[y][x]:
            return
        r, g, b, a = pixels[x, y]
        if a < 8:
            transparent[y][x] = True
            return
        if is_background_pixel(r, g, b):
            transparent[y][x] = True

    queue: deque[tuple[int, int]] = deque()
    for x in range(w):
        for y in (0, h - 1):
            try_mark(x, y)
            if transparent[y][x]:
                queue.append((x, y))
    for y in range(h):
        for x in (0, w - 1):
            try_mark(x, y)
            if transparent[y][x] and (x, y) not in queue:
                queue.append((x, y))

    while queue:
        x, y = queue.popleft()
        for nx, ny in ((x - 1, y), (x + 1, y), (x, y - 1), (x, y + 1)):
            if 0 <= nx < w and 0 <= ny < h and not transparent[ny][nx]:
                r, g, b, a = pixels[nx, ny]
                if a < 8 or is_background_pixel(r, g, b):
                    transparent[ny][nx] = True
                    queue.append((nx, ny))

    for y in range(h):
        for x in range(w):
            if transparent[y][x]:
                r, g, b, _ = pixels[x, y]
                pixels[x, y] = (r, g, b, 0)

    return rgba


def git_restore(rel: str) -> None:
    path = ROOT / rel
    data = subprocess.check_output(["git", "show", f"{ART_REV}:{rel}"])
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_bytes(data)


def main() -> int:
    for rel in NEW_SPRITES:
        git_restore(rel)
        path = ROOT / rel
        img = Image.open(path)
        out = flood_transparent(img)
        alpha = out.split()[3].getextrema()
        out.save(path, format="PNG", optimize=True)
        print(f"ok: {rel} {img.size} alpha={alpha}")
    print(f"done: {len(NEW_SPRITES)} sprites from {ART_REV}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
