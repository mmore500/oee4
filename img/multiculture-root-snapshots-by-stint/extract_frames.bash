#!/bin/bash
# Reproduces the snapshot PNGs in this folder from source.
#
# Source videos: phylogenetic-root drawings for case-study series 16005,
# bucket prq49, endeavor 16, "multicultures-lowestandhighestroot-extended".
# Each video samples the simulation every 64 updates, starting at update 64.
#
# Frame indices below (0-indexed, matching ffmpeg's select filter) were
# chosen to land on updates 64, 128, 256, 512, 1024, 2048, 4096, 8192:
#   update = 64 * (frame_index + 1)
#     frame 0   -> update 64
#     frame 1   -> update 128
#     frame 3   -> update 256
#     frame 7   -> update 512
#     frame 15  -> update 1024
#     frame 31  -> update 2048
#     frame 63  -> update 4096
#     frame 127 -> update 8192

set -e

# stint -> video's final update (i.e. its "update=64-<END>%64" suffix on S3)
declare -A stint_end=(
  [10]=49152 [15]=16384 [20]=57664 [30]=44480 [40]=40896 [50]=38912
  [60]=16384 [70]=15424 [80]=36032 [90]=38272 [100]=18816
)

WORKDIR="$(mktemp -d)"
cd "$WORKDIR"

for stint in 10 15 20 30 40 50 60 70 80 90 100; do
  end="${stint_end[$stint]}"
  uri="s3://prq49/endeavor=16/multicultures-lowestandhighestroot-extended/videos/stage=1+what=generated/stint=${stint}/series=16005/a=phylogenetic-root+idx=0+proc=0+series=16005+stint=${stint}+thread=0+update=64-${end}%64+ext=.mp4"

  aws s3 cp "${uri}" "stint${stint}.mp4" --no-sign-request

  ffmpeg -y -i "stint${stint}.mp4" \
    -vf "select='eq(n\,0)+eq(n\,1)+eq(n\,3)+eq(n\,7)+eq(n\,15)+eq(n\,31)+eq(n\,63)+eq(n\,127)'" \
    -vsync 0 "stint${stint}_%d.png"

  # ffmpeg numbers selected frames sequentially (1..8); map back to the
  # update value each one corresponds to.
  updates=(64 128 256 512 1024 2048 4096 8192)
  for i in 1 2 3 4 5 6 7 8; do
    u="${updates[$((i - 1))]}"
    cp "stint${stint}_${i}.png" "$OLDPWD/s${stint}_u${u}.png"
  done
done

cd "$OLDPWD"
rm -rf "$WORKDIR"

# Losslessly (visually) shrink the flat-colored drawings from ~36MB to
# ~3.4MB total by quantizing to a 16-color palette at full 500x500
# resolution (no resizing).
mogrify -colors 16 -strip -define png:compression-level=9 s*_u*.png
