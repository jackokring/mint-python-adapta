#!/usr/bin/env python3
"""
Center one SVG (app icon) inside another SVG (document icon) and save the result.

Usage:
  python compose_svg.py --doc document.svg --app app.svg --out out.svg
  # Optional controls:
  python compose_svg.py --doc document.svg --app app.svg --out out.svg --fit 0.7
  python compose_svg.py --doc document.svg --app app.svg --out out.svg --inner 8,8,80,80
"""
import argparse
import re
import sys
import xml.etree.ElementTree as ET
from copy import deepcopy

# Keep SVG namespace intact
SVG_NS = "http://www.w3.org/2000/svg"
XLINK_NS = "http://www.w3.org/1999/xlink"
ET.register_namespace("", SVG_NS)
ET.register_namespace("xlink", XLINK_NS)

def parse_len(s):
    """Parse an SVG length (px, pt, mm, cm, in). Returns value in px."""
    if s is None:
        return None
    s = str(s).strip()
    m = re.match(r"^\s*([+-]?\d*\.?\d+)\s*([a-z%]*)\s*$", s, re.I)
    if not m:
        return None
    val = float(m.group(1))
    unit = m.group(2).lower()
    # Convert to px; 1in=96px, 1pt=1.3333px, 1mm≈3.7795px, 1cm=37.795px
    conv = {
        "": 1.0, "px": 1.0,
        "pt": 96.0/72.0,
        "in": 96.0,
        "mm": 96.0/25.4,
        "cm": 96.0/2.54,
    }
    return val * conv.get(unit, 1.0)

def get_viewbox_or_size(root):
    """
    Return (minx, miny, w, h) in px from <svg> element.
    Prefers viewBox; falls back to width/height with 0,0 origin.
    """
    vb = root.get("viewBox")
    if vb:
        parts = [float(x) for x in re.split(r"[\s,]+", vb.strip()) if x]
        if len(parts) == 4:
            return tuple(parts)  # already user units
    w = parse_len(root.get("width"))
    h = parse_len(root.get("height"))
    if w is None or h is None:
        raise ValueError("SVG must have a viewBox or width/height.")
    return (0.0, 0.0, w, h)

def ensure_defs(root):
    """Ensure a single <defs> exists; return it."""
    for child in root:
        if child.tag == f"{{{SVG_NS}}}defs":
            return child
    defs = ET.Element(f"{{{SVG_NS}}}defs")
    # Put defs at top for good measure
    root.insert(0, defs)
    return defs

def move_defs_into(target_defs, src_root):
    """Copy <defs> children from src into target <defs> (shallow, no dedup)."""
    for child in list(src_root):
        if child.tag == f"{{{SVG_NS}}}defs":
            for item in list(child):
                target_defs.append(deepcopy(item))

def parse_inner_rect(arg, doc_box):
    """
    Parse --inner x,y,w,h (in document viewBox units). If not given, use full doc box.
    """
    if not arg:
        return doc_box
    try:
        x, y, w, h = [float(v.strip()) for v in arg.split(",")]
        return (x, y, w, h)
    except Exception:
        raise ValueError("--inner must be 'x,y,w,h' (numbers)")

def main():
    ap = argparse.ArgumentParser(description="Center an app SVG inside a document SVG.")
    ap.add_argument("--doc", required=True, help="Path to the document/background SVG")
    ap.add_argument("--app", required=True, help="Path to the app/foreground SVG")
    ap.add_argument("--out", required=True, help="Output SVG path")
    ap.add_argument("--fit", type=float, default=0.8,
                    help="Fraction of inner box size to fill (0<fit<=1). Default 0.8")
    ap.add_argument("--inner", default=None,
                    help="Inner content rect in doc viewBox units: x,y,w,h "
                         "(defaults to full doc viewBox).")
    args = ap.parse_args()

    if not (0 < args.fit <= 1.0):
        print("--fit must be in (0,1].", file=sys.stderr)
        sys.exit(2)

    # Load SVGs
    doc_tree = ET.parse(args.doc)
    doc_root = doc_tree.getroot()
    app_tree = ET.parse(args.app)
    app_root = app_tree.getroot()

    # Determine geometry
    doc_minx, doc_miny, doc_w, doc_h = get_viewbox_or_size(doc_root)
    app_minx, app_miny, app_w, app_h = get_viewbox_or_size(app_root)

    inner_x, inner_y, inner_w, inner_h = parse_inner_rect(args.inner, (doc_minx, doc_miny, doc_w, doc_h))

    # Target box after applying fit
    target_w = inner_w * args.fit
    target_h = inner_h * args.fit
    scale = min(target_w / app_w, target_h / app_h)

    # Size of app after scaling
    placed_w = app_w * scale
    placed_h = app_h * scale

    # Center inside inner rect
    tx = inner_x + (inner_w - placed_w) / 2.0 - app_minx * scale
    ty = inner_y + (inner_h - placed_h) / 2.0 - app_miny * scale

    # Merge <defs> so gradients/filters still work
    doc_defs = ensure_defs(doc_root)
    move_defs_into(doc_defs, app_root)

    # Wrap app content in a group with transform
    g = ET.Element(f"{{{SVG_NS}}}g")
    g.set("id", "inserted-app-icon")
    g.set("transform", f"translate({tx:.6f},{ty:.6f}) scale({scale:.6f})")

    # Move all *visual* children of app_root into the group (skip its <defs>)
    for child in list(app_root):
        if child.tag == f"{{{SVG_NS}}}defs":
            continue
        g.append(deepcopy(child))

    # Append to document root as last child so it renders on top
    doc_root.append(g)

    # Ensure the document has a viewBox (helps when doc only had width/height)
    if doc_root.get("viewBox") is None:
        doc_root.set("viewBox", f"{doc_minx} {doc_miny} {doc_w} {doc_h}")

    # Save
    doc_tree.write(args.out, encoding="utf-8", xml_declaration=True)
    print(f"Wrote {args.out}")

if __name__ == "__main__":
    main()

