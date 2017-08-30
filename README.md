# arrcheck: Warn on array usage in POSIX sh scripts

# ABOUT

While waiting on common shell script linters like checkbashisms to add a rule for using arrays, which are not present in POSIX sh, we present arraycheck, a quick and dirty script dedicated to warning when POSIX sh scripts attempt to use obviously bash-derived array syntaxes.

arrcheck looks for common syntax indicative of bash-derived array usage:

* `$somearray[@]` pattern used in for loops
* `$somearray[*]` string joining

Note that using the syntax `for element in $somearray; do ... done` is technically bash and POSIX compatible, but will result in only one iteration, over the first array element. This is bad form, compared to the safer `for element in "${somearray[@]}"; do ... done` form (bash-like), or else the `for element; do ... done` form implicitly using the `$@` argv variable (POSIX sh).

arrcheck also ignores any array syntax sent to `bash` invocations, that the POSIX sh would not be responsible for parsing. This is actually helpful, as it encourages bashisms to be isolated in `#!/bin/bash` AKA `.bash` scripts separate from pure POSIX sh code.

# KNOWN BUGS

If no sh scripts are found, arrcheck returns a nonzero exit status as a quirk of the current pipe, BSD-compatible xargs, and grep implementation:

```console
$ stank examples/no-shell-scripts
$ arrcheck examples/no-shell-scripts
$ echo "$?"
1
```

Scripts clearly marked as bash derivatives are not currently excluded from results:

```console
$ arrcheck examples
examples/apples.bash:for apple in "${APPLES[@]}"; do
examples/upturnedcart.sh:for apple in "${APPLES[@]}"; do

$ head examples/apples.bash
#!/bin/bash
```

Array literals `(...)`, `$somearray[someexpression]`, `"$somearray[someexpression]"`, and `${somearray[someexpression]}"` are not checked. These forms are best checked by a full AST bash parser, and so a replacement implementation is planned for arrcheck to make use of https://github.com/mvdan/sh

# INSTALL

1. Clone arrcheck.
2. Add `lib` to `$PATH`.
