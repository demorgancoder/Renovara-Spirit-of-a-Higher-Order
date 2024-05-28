#!/bin/bash
wla-65816 -o "renovara.obj" "renovara.asm"
wlalink "renovara.lnk" "renovara.sfc"
bsnes "renovara.sfc"
