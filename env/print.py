import _env

variables = {k: v for k, v in vars(_env).items()}
for name, value in variables.items():
    if name.startswith("MB_"):
        print(f"{name} {value}")
