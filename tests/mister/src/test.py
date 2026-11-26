#!/usr/bin/env python3
"""Build and validate the tests/mister harness.

The C++ test executable only drives the Verilog wrapper and prints raw model
output. This Python driver owns the test configuration: it loads the expected
CSV files, groups samples by button/scandouble state, invokes test.exe for the
required ticks, and compares the returned values.

Generated build output stays under out/tests/mister.
"""

import csv
import subprocess
import sys
from pathlib import Path


MAKE_DIR = Path(__file__).resolve().parent.parent
PROJECT_ROOT = MAKE_DIR.parent.parent
EXE = PROJECT_ROOT / "out" / "tests" / "mister" / "test.exe"
REPORT = EXE.parent / "results.md"
DATA_DIR = Path(sys.argv[1]) if len(sys.argv) > 1 else MAKE_DIR / "test_data"
SAMPLES_CSV = DATA_DIR / "expected_samples.csv"
RESET_CSV = DATA_DIR / "expected_reset.csv"

SAMPLE_CONFIG_FIELDS = ["reset", "buttons", "scandouble", "pal"]
SAMPLE_OUTPUT_FIELDS = [
    "ce_pix",
    "hvcnt_atzero",
    "HBlank",
    "HSync",
    "VBlank",
    "VSync",
    "rgb_data",
]

RESET_CONFIG_FIELDS = ["buttons", "scandouble", "pal"]
RESET_OUTPUT_FIELDS = [
    "ce_pix",
    "hvcnt_atzero",
    "HBlank",
    "HSync",
    "VBlank",
    "VSync",
]


def read_csv_rows(path: Path) -> list[dict[str, int]]:
    with path.open(newline="", encoding="utf-8") as f:
        reader = csv.DictReader(f)
        rows = []
        for row in reader:
            values = {}
            for key, value in row.items():
                if value is not None and value != "":
                    values[key] = int(value)
            rows.append(values)
        return rows


def build_if_needed() -> None:
    if not EXE.exists():
        subprocess.check_call(["make", "-C", str(MAKE_DIR), "test.exe"])


def run_model(args: list[str]) -> list[dict[str, int]]:
    output = subprocess.check_output([str(EXE)] + args, text=True)
    rows = []
    for line in output.splitlines():
        line = line.strip()
        if not line:
            continue
        values = [int(v) for v in line.split(",")]
        if len(values) != 8:
            raise ValueError(f"bad test.exe output row: {line}")
        rows.append(
            {
                "tick": values[0],
                "ce_pix": values[1],
                "hvcnt_atzero": values[2],
                "HBlank": values[3],
                "HSync": values[4],
                "VBlank": values[5],
                "VSync": values[6],
                "rgb_data": values[7],
            }
        )
    return rows


def compare_row(expected: dict[str, int], actual: dict[str, int], fields: list[str]) -> bool:
    ok = True
    for field in fields:
        if expected[field] != actual[field]:
            print(
                f"FAIL {field}: expected={expected[field]} actual={actual[field]}"
            )
            ok = False
    return ok


def table_separator(columns: int) -> str:
    return "| " + " | ".join(["---"] * columns) + " |"


def main() -> int:
    if not SAMPLES_CSV.exists():
        print(f"missing sample config: {SAMPLES_CSV}", file=sys.stderr)
        return 2
    if not RESET_CSV.exists():
        print(f"missing reset config: {RESET_CSV}", file=sys.stderr)
        return 2

    build_if_needed()

    samples = read_csv_rows(SAMPLES_CSV)
    resets = read_csv_rows(RESET_CSV)

    groups: dict[tuple[int, int, int, int], list[dict[str, int]]] = {}
    for sample in samples:
        key = tuple(sample[field] for field in SAMPLE_CONFIG_FIELDS)
        groups.setdefault(key, []).append(sample)

    checks = 0
    failures = 0
    sample_report_rows = []
    reset_report_rows = []
    failure_rows = []

    for key, expected_rows in sorted(groups.items()):
        reset, buttons, scandouble, pal = key
        expected_rows.sort(key=lambda row: row["tick"])
        ticks = [str(row["tick"]) for row in expected_rows]

        args = ["--buttons", str(buttons), "--pal", str(pal), "--ticks", ",".join(ticks)]
        if scandouble:
            args.append("--scandouble")
        if reset:
            args.append("--reset")

        actual_rows = run_model(args)
        actual_by_tick = {row["tick"]: row for row in actual_rows}

        group_checks = 0
        group_failures = 0

        for expected in expected_rows:
            tick = expected["tick"]
            actual = actual_by_tick.get(tick)
            group_checks += 1
            checks += 1
            if actual is None:
                print(
                    f"FAIL missing model output: reset={reset} buttons={buttons} "
                    f"scandouble={scandouble} pal={pal} tick={tick}"
                )
                failures += 1
                group_failures += 1
                failure_rows.append(
                    (f"reset={reset} buttons={buttons} scandouble={scandouble} pal={pal}",
                     tick, "missing output", "none", "none")
                )
                continue

            label = (
                f"reset={reset} buttons={buttons} scandouble={scandouble} "
                f"pal={pal} tick={tick}"
            )
            row_ok = True
            for field in SAMPLE_OUTPUT_FIELDS:
                if expected[field] != actual[field]:
                    print(
                        f"FAIL {label} {field}: expected={expected[field]} "
                        f"actual={actual[field]}"
                    )
                    failure_rows.append(
                        (
                            f"reset={reset} buttons={buttons} "
                            f"scandouble={scandouble} pal={pal}",
                            tick,
                            field,
                            expected[field],
                            actual[field],
                        )
                    )
                    row_ok = False
            if not row_ok:
                failures += 1
                group_failures += 1

        sample_report_rows.append(
            (reset, buttons, scandouble, pal, group_checks, group_failures)
        )

    for expected in resets:
        buttons = expected["buttons"]
        scandouble = expected["scandouble"]
        pal = expected["pal"]

        args = ["--buttons", str(buttons), "--pal", str(pal), "--reset"]
        if scandouble:
            args.append("--scandouble")

        actual_rows = run_model(args)
        reset_checks = 1
        reset_failures = 0
        checks += 1

        actual = next((row for row in actual_rows if row["tick"] == -1), None)
        if actual is None:
            print(
                f"FAIL missing reset output: buttons={buttons} "
                f"scandouble={scandouble} pal={pal}"
            )
            failures += 1
            reset_failures += 1
            failure_rows.append(
                (
                    f"buttons={buttons} scandouble={scandouble} pal={pal}",
                    -1,
                    "missing reset output",
                    "none",
                    "none",
                )
            )
            reset_report_rows.append(
                (buttons, scandouble, pal, reset_checks, reset_failures)
            )
            continue

        row_ok = True
        for field in RESET_OUTPUT_FIELDS:
            if expected[field] != actual[field]:
                print(
                    f"FAIL reset buttons={buttons} scandouble={scandouble} "
                    f"pal={pal} {field}: expected={expected[field]} "
                    f"actual={actual[field]}"
                )
                failure_rows.append(
                    (
                        f"buttons={buttons} scandouble={scandouble} pal={pal}",
                        -1,
                        field,
                        expected[field],
                        actual[field],
                    )
                )
                row_ok = False
        if not row_ok:
            failures += 1
            reset_failures += 1

        reset_report_rows.append(
            (buttons, scandouble, pal, reset_checks, reset_failures)
        )

    status = "PASS" if failures == 0 else "FAIL"
    print(f"{status} checks={checks} failures={failures}")

    REPORT.parent.mkdir(parents=True, exist_ok=True)
    lines = [
        "# tests/mister results",
        "",
        f"Status: **{status}**",
        f"Checks: {checks}",
        f"Failures: {failures}",
        "",
        "## Sample groups",
        "",
        "| reset | buttons | scandouble | pal | checks | failures | status |",
        table_separator(7),
    ]
    for reset, buttons, scandouble, pal, group_checks, group_failures in sample_report_rows:
        group_status = "PASS" if group_failures == 0 else "FAIL"
        lines.append(
            f"| {reset} | {buttons} | {scandouble} | {pal} | "
            f"{group_checks} | {group_failures} | {group_status} |"
        )
    lines.extend([
        "",
        "## Reset checks",
        "",
        "| buttons | scandouble | pal | checks | failures | status |",
        table_separator(6),
    ])
    for buttons, scandouble, pal, reset_checks, reset_failures in reset_report_rows:
        reset_status = "PASS" if reset_failures == 0 else "FAIL"
        lines.append(
            f"| {buttons} | {scandouble} | {pal} | {reset_checks} | "
            f"{reset_failures} | {reset_status} |"
        )

    lines.extend([
        "",
        "## Failure details",
        "",
    ])
    if failure_rows:
        lines.extend([
            "| group | tick | field | expected | actual |",
            table_separator(5),
        ])
        for group, tick, field, expected_value, actual_value in failure_rows:
            lines.append(
                f"| {group} | {tick} | {field} | {expected_value} | {actual_value} |"
            )
    else:
        lines.append("None.")
    lines.append("")

    REPORT.write_text("\n".join(lines), encoding="utf-8")
    print(f"report: {REPORT}")
    return 0 if failures == 0 else 1


if __name__ == "__main__":
    sys.exit(main())
