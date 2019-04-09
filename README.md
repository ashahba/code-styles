## **Coding style**
### Handy script to check styles for mixed shell and python scripts

### **General style guides:**
- **_All text files:_** We try not to have multiple consecutive blank lines on any given code file unless it's
mandated by other formatters.
- We try no to leave any extra whitespaces after end of line or at the end of text files.
We also like to have an end of line char at the end of all text files, except images or
archives.

- **_Shell scripts:_** We use [shfmt](https://github.com/mvdan/sh) to parse and format

- **_Python scripts:_** We use `Google`'s [yapf](https://github.com/google/yapf) to
format `Python` scripts based on [pep8](https://www.python.org/dev/peps/pep-0008/).

- We also use `flake8` to test for correctness of `Python` code styles.

To check for rules above please run "[check_code_styles.sh](./check_code_styles.sh)"
