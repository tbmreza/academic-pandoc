import argparse
from pathlib import Path

import whisper


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument("video", type=Path)
    parser.add_argument(
        "--model",
        default="small",
        help="Whisper model: tiny, base, small, medium, large, turbo",
    )
    args = parser.parse_args()

    video = args.video

    if not video.exists():
        raise SystemExit(f"File not found: {video}")

    print(f"Loading Whisper model: {args.model}")
    model = whisper.load_model(args.model)

    print(f"Transcribing: {video}")
    result = model.transcribe(
        str(video),
        fp16=False,
    )

    output = video.with_suffix(".txt")
    output.write_text(result["text"].strip() + "\n", encoding="utf-8")

    print(f"Transcript written to: {output}")


if __name__ == "__main__":
    main()
