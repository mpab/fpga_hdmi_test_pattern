#!/usr/bin/env python3
"""Build and validate the tests/hdl harness.

The C++ test executable only drives the Verilog wrapper and prints raw model
output. This Python driver owns the test configuration: it loads the expected
CSV files, groups samples by resolution/pattern, invokes test.exe for the
required ticks, and compares the returned values.

Generated build output stays under out/tests/hdl.
"""

import csv
import subprocess
import sys
from pathlib import Path


MAKE_DIR = Path(__file__).resolve().parent.parent
PROJECT_ROOT = MAKE_DIR.parent.parent
EXE = PROJECT_ROOT / "out" / "tests" / "hdl" / "test.exe"
REPORT = EXE.parent / "results.md"
DATA_DIR = Path(sys.argv[1]) if len(sys.argv) > 1 else MAKE_DIR / "test_data"
SAMPLES_CSV = DATA_DIR / "expected_samples.csv"
RESET_CSV = DATA_DIR / "expected_reset.csv"

SAMPLE_FIELDS = [
    "beam_x",
    "beam_y",
    "h_sync",
    "v_sync",
    "h_blank",
    "v_blank",
    "de",
    "frame_start",
    "line_start",
    "beam_at_zero",
    "rgb_data",
]

RESET_FIELDS = [
    "beam_x",
    "beam_y",
    "h_sync",
    "v_sync",
    "h_blank",
    "v_blank",
    "de",
    "frame_start",
    "line_start",
    "beam_at_zero",
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
        if len(values) != 12:
            raise ValueError(f"bad test.exe output row: {line}")
        rows.append(
            {
                "tick": values[0],
                "beam_x": values[1],
                "beam_y": values[2],
                "h_sync": values[3],
                "v_sync": values[4],
                "h_blank": values[5],
                "v_blank": values[6],
                "de": values[7],
                "frame_start": values[8],
                "line_start": values[9],
                "beam_at_zero": values[10],
                "rgb_data": values[11],
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

    groups: dict[tuple[int, int], list[dict[str, int]]] = {}
    for sample in samples:
        key = (sample["res_sel"], sample["pattern_sel"])
        groups.setdefault(key, []).append(sample)

    checks = 0
    failures = 0
    sample_report_rows = []
    reset_report_rows = []
    failure_rows = []

    for (res, pattern), expected_rows in sorted(groups.items()):
        expected_rows.sort(key=lambda row: row["tick"])
        ticks = [str(row["tick"]) for row in expected_rows]

        actual_rows = run_model(
            ["--res", str(res), "--pattern", str(pattern), "--ticks", ",".join(ticks)]
        )
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
                    f"FAIL missing model output: res={res} pattern={pattern} tick={tick}"
                )
                failures += 1
                group_failures += 1
                failure_rows.append((res, pattern, tick, "missing output", "none", "none"))
                continue

            label = f"res={res} pattern={pattern} tick={tick}"
            row_ok = True
            for field in SAMPLE_FIELDS:
                if expected[field] != actual[field]:
                    print(
                        f"FAIL {label} {field}: expected={expected[field]} actual={actual[field]}"
                    )
                    failure_rows.append(
                        (res, pattern, tick, field, expected[field], actual[field])
                    )
                    row_ok = False
            if not row_ok:
                failures += 1
                group_failures += 1

        sample_report_rows.append((res, pattern, group_checks, group_failures))

    for expected in resets:
        res = expected["res_sel"]
        actual_rows = run_model(["--res", str(res), "--pattern", "0", "--reset"])
        reset_checks = 1
        reset_failures = 0
        checks += 1

        if not actual_rows:
            print(f"FAIL missing reset output: res={res}")
            failures += 1
            reset_failures += 1
            failure_rows.append((res, 0, -1, "missing reset output", "none", "none"))
            reset_report_rows.append((res, reset_checks, reset_failures))
            continue

        actual = actual_rows[0]
        row_ok = True
        for field in RESET_FIELDS:
            if expected[field] != actual[field]:
                print(
                    f"FAIL reset res={res} {field}: expected={expected[field]} actual={actual[field]}"
                )
                failure_rows.append((res, 0, -1, field, expected[field], actual[field]))
                row_ok = False
        if not row_ok:
            failures += 1
            reset_failures += 1

        reset_report_rows.append((res, reset_checks, reset_failures))

    status = "PASS" if failures == 0 else "FAIL"
    print(f"{status} checks={checks} failures={failures}")

    REPORT.parent.mkdir(parents=True, exist_ok=True)
    lines = [
        "# tests/hdl results",
        "",
        f"Status: **{status}**",
        f"Checks: {checks}",
        f"Failures: {failures}",
        "",
        "## Sample groups",
        "",
        "| res_sel | pattern_sel | checks | failures | status |",
        table_separator(5),
    ]
    for res, pattern, group_checks, group_failures in sample_report_rows:
        group_status = "PASS" if group_failures == 0 else "FAIL"
        lines.append(
            f"| {res} | {pattern} | {group_checks} | {group_failures} | {group_status} |"
        )
    lines.extend([
        "",
        "## Reset checks",
        "",
        "| res_sel | checks | failures | status |",
        table_separator(4),
    ])
    for res, reset_checks, reset_failures in reset_report_rows:
        reset_status = "PASS" if reset_failures == 0 else "FAIL"
        lines.append(
            f"| {res} | {reset_checks} | {reset_failures} | {reset_status} |"
        )

    lines.extend([
        "",
        "## Failure details",
        "",
    ])
    if failure_rows:
        lines.extend([
            "| res_sel | pattern_sel | tick | field | expected | actual |",
            table_separator(6),
        ])
        for res, pattern, tick, field, expected_value, actual_value in failure_rows:
            lines.append(
                f"| {res} | {pattern} | {tick} | {field} | {expected_value} | {actual_value} |"
            )
    else:
        lines.append("None.")
    lines.append("")

    REPORT.write_text("\n".join(lines), encoding="utf-8")
    print(f"report: {REPORT}")
    return 0 if failures == 0 else 1


if __name__ == "__main__":
    sys.exit(main())
