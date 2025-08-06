import sys


def check_placeholders(file_path):
    with open(file_path, "r") as f:
        content = f.read()
        if "<REPLACE_ME" in content:
            print("Placeholders found")
            sys.exit(1)


if __name__ == "__main__":
    check_placeholders(sys.argv[1])
