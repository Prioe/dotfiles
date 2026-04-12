#!/usr/bin/env bash
# Restore the vertical monitor workspace layout.
# Workspace 6 on the portrait display (DP-3).
#
# Layout:
#   top 1/3  – tabbed media   (Brave PWAs: YouTube/Netflix, Spotify)
#   bot 2/3  – tabbed comms   (Zen Browser, Discord)
#
# Finds running instances of the above apps and rearranges them.
# Safe to run multiple times.

set -euo pipefail

readonly WS=6
readonly MARK_WS="_vl_ws"
readonly MARK_MEDIA="_vl_media"
readonly MARK_BOTTOM="_vl_bottom"

sw() { swaymsg "$@" >/dev/null 2>&1; }

TREE=$(swaymsg -t get_tree)

jq_ids() {
    printf '%s' "$TREE" | jq -r "[${1}] | unique | .[]"
}

# ── Discover windows ───────────────────────────────────────────────────────

# Media: Brave PWAs (YouTube, Netflix, …), Spotify
mapfile -t MEDIA_IDS < <(jq_ids '
  .. | objects | select(
    ((.app_id // "") | startswith("brave-")) or
    ((.window_properties.class // "") | ascii_downcase | test("^spotify$"))
  ) | .id
')

# Bottom: Zen Browser, Discord
mapfile -t BOTTOM_IDS < <(jq_ids '
  .. | objects | select(
    (.app_id // "") == "zen" or
    ((.window_properties.class // "") | ascii_downcase | test("^discord$"))
  ) | .id
')

if [[ ${#MEDIA_IDS[@]} -eq 0 && ${#BOTTOM_IDS[@]} -eq 0 ]]; then
    echo "No matching windows found" >&2
    exit 1
fi

echo "Media  [${#MEDIA_IDS[@]}]: ${MEDIA_IDS[*]:-none}"
echo "Bottom [${#BOTTOM_IDS[@]}]: ${BOTTOM_IDS[*]:-none}"

# ── Park everything in scratchpad ──────────────────────────────────────────

ALL_IDS=("${MEDIA_IDS[@]}" "${BOTTOM_IDS[@]}")
for id in "${ALL_IDS[@]}"; do
    sw "[con_id=${id}] move to scratchpad"
done

sw "workspace number ${WS}"

MEDIA_ANCHOR="${MEDIA_IDS[0]:-}"
BOTTOM_ANCHOR="${BOTTOM_IDS[0]:-}"

# ── Place one anchor per section at workspace root ─────────────────────────
# The workspace root will be splitv when both sections are present.

if [[ -n "${MEDIA_ANCHOR}" ]]; then
    sw "[con_id=${MEDIA_ANCHOR}] scratchpad show"
    sw "[con_id=${MEDIA_ANCHOR}] floating disable"
    sw "[con_id=${MEDIA_ANCHOR}] focus"
    [[ -n "${BOTTOM_ANCHOR}" ]] && sw "layout splitv"
    sw "[con_id=${MEDIA_ANCHOR}] mark --replace ${MARK_WS}"
fi

if [[ -n "${BOTTOM_ANCHOR}" ]]; then
    sw "[con_id=${BOTTOM_ANCHOR}] scratchpad show"
    sw "[con_id=${BOTTOM_ANCHOR}] floating disable"
    # move to mark ensures it lands as a sibling of the media anchor
    [[ -n "${MEDIA_ANCHOR}" ]] && sw "[con_id=${BOTTOM_ANCHOR}] move to mark ${MARK_WS}"
fi

# ── Wrap each section in its own tabbed container (only if > 1 window) ─────
# splith wraps the anchor in a new container; layout tabbed changes it.

if [[ -n "${MEDIA_ANCHOR}" && ${#MEDIA_IDS[@]} -gt 1 ]]; then
    sw "[con_id=${MEDIA_ANCHOR}] splith"
    sw "[con_id=${MEDIA_ANCHOR}] layout tabbed"
    sw "[con_id=${MEDIA_ANCHOR}] mark --replace ${MARK_MEDIA}"
    for id in "${MEDIA_IDS[@]:1}"; do
        sw "[con_id=${id}] scratchpad show"
        sw "[con_id=${id}] floating disable"
        sw "[con_id=${id}] move to mark ${MARK_MEDIA}"
        sw "[con_id=${id}] mark --add ${MARK_MEDIA}"
    done
fi

if [[ -n "${BOTTOM_ANCHOR}" && ${#BOTTOM_IDS[@]} -gt 1 ]]; then
    sw "[con_id=${BOTTOM_ANCHOR}] splith"
    sw "[con_id=${BOTTOM_ANCHOR}] layout tabbed"
    sw "[con_id=${BOTTOM_ANCHOR}] mark --replace ${MARK_BOTTOM}"
    for id in "${BOTTOM_IDS[@]:1}"; do
        sw "[con_id=${id}] scratchpad show"
        sw "[con_id=${id}] floating disable"
        sw "[con_id=${id}] move to mark ${MARK_BOTTOM}"
        sw "[con_id=${id}] mark --add ${MARK_BOTTOM}"
    done
fi

# ── Resize: media = top 1/3, bottom = remaining 2/3 ───────────────────────

if [[ -n "${MEDIA_ANCHOR}" && -n "${BOTTOM_ANCHOR}" ]]; then
    sw "[con_id=${MEDIA_ANCHOR}] focus"
    sw "resize set height 33 ppt"
fi

echo "Done."
