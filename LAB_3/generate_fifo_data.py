import argparse
import random
from pathlib import Path


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("--width", type=int, default=16)
    parser.add_argument("--count", type=int, default=32)
    parser.add_argument("--seed", type=int, default=520)
    args = parser.parse_args()

    if args.width < 1:
        raise ValueError("width must be at least 1")
    if args.count < 1:
        raise ValueError("count must be at least 1")

    mask = (1 << args.width) - 1

    alternating_a = 0
    for bit in range(1, args.width, 2):
        alternating_a |= (1 << bit)

    alternating_5 = mask ^ alternating_a

    values = [
        0,
        mask,
        alternating_a,
        alternating_5,
    ]

    rng = random.Random(args.seed)

    while len(values) < args.count:
        values.append(rng.getrandbits(args.width))

    values = values[:args.count]

    hex_digits = (args.width + 3) // 4
    output_path = Path(__file__).resolve().with_name("input_data.txt")

    with output_path.open("w", encoding="utf-8") as output_file:
        for value in values:
            output_file.write(f"{value:0{hex_digits}X}\n")

    print(f"Wrote {len(values)} values to {output_path}")


if __name__ == "__main__":
    main()