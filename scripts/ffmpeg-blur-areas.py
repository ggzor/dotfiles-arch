#!/usr/bin/env python3

import argparse
import dataclasses
import fileinput
import re
import sys


sB = "\033[1m"
sR = "\033[0m"


def parse_args():
    args = argparse.ArgumentParser(
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog=f"""\
Generate a ffmpeg {sB}-filter_complex{sR} to blur areas of a video using the
lines of FILE as input, with the following format:

    {sB}start end x,y wxh{sR}

where
    {sB}start{sR} and {sB}end{sR} are timestamps [hh:][mm:]ss[.ms]

Then, you can use this filter as follows:

    ffmpeg -i in.mp4 -filter_complex "$(ffmpeg-blur-areas.py areas.txt)" out.mp4
""",
    )
    args.add_argument("file", help="The FILE to read or -", metavar="FILE")
    return args.parse_args()


TIMESTAMP = r"(?:(\d{2}):)?(?:(\d{2}):)?(\d+)(?:.(\d+))?"
TIMESTAMP_RE = re.compile(TIMESTAMP)
LINE_RE = re.compile(
    rf"(?P<start>{TIMESTAMP})\s+(?P<end>{TIMESTAMP})\s+(?P<x>\d+),(?P<y>\d+)\s+(?P<w>\d+)x(?P<h>\d+)"
)


def process_timestamp(ts):
    if match := TIMESTAMP_RE.match(ts):
        h, m, s, ms = map(int, match.groups())
        total_seconds = h * 60 * 60 + m * 60 + s
        return f"{total_seconds}.{ms}"
    else:
        # Impossible
        exit(1)


@dataclasses.dataclass
class BlurArea:
    start: str
    end: str
    x: int
    y: int
    w: int
    h: int


INPUT = "[0]"
BLUR_AREA_NAME = "blurarea"
BLUR_INTENSITY = 10
OUTPUT = ""


def main(args):
    areas: list[BlurArea] = []
    for line in fileinput.input(args.file):
        if m := LINE_RE.match(line.strip()):
            d = m.groupdict()
            areas.append(
                BlurArea(
                    start=process_timestamp(d["start"]),
                    end=process_timestamp(d["end"]),
                    x=int(d["x"]),
                    y=int(d["y"]),
                    w=int(d["w"]),
                    h=int(d["h"]),
                )
            )
        else:
            print("Invalid line:", line, file=sys.stderr)
            exit(1)

    for i, a in enumerate(areas):
        print(
            f"{INPUT}crop={a.w}:{a.h}:{a.x}:{a.y}"
            f",boxblur={BLUR_INTENSITY}:enable='between(t, {a.start}, {a.end})'"
            f" [{BLUR_AREA_NAME}mid{i}];"
        )

    for i, a in enumerate(areas):
        first = INPUT if i == 0 else f" [{BLUR_AREA_NAME}out{i - 1}]"
        second = f"[{BLUR_AREA_NAME}mid{i}]"
        last = OUTPUT if i + 1 == len(areas) else f"[{BLUR_AREA_NAME}out{i}];"
        print(
            f"{first}{second} overlay={a.x}:{a.y}:enable='between(t, {a.start}, {a.end})'"
            f" {last}"
        )


if __name__ == "__main__":
    main(parse_args())
