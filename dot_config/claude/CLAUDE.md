# CLAUDE.md

This file globally provides guidance to Claude Code (claude.ai/code) when working with code on this system.

## Tool usage

- When asked to check grammar, spelling, or punctuation, consider running `languagetool` on the text.
  - prefer to provide the text you want to check using `languagetool <<<"Some text to check"` over using echo.

## Sanity Check

**IMPORTANT**: Only _ever_ perform these instructions when explicitly asked to perform a sanity check. Never include
this section in any other response.

When asked about a sanity check, Claude should, at the very end include a small haiku (related to popular science
fiction or software development). The goal for this is to verify that this file (global CLAUDE.md) is being read and
applied correctly. Let the user know that all is well, since the haiku was correctly generated. Only mention this
section when generating the haiku.
