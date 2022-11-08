#!/bin/bash

# This script can be used to run flutter test for a given directory (defaults to the current directory)
# It will exclude generated code and translations (mimicking the ci) and open the coverage report in a
# new window once it has run successfully.
#
# To run in main project:
# ./tool/coverage.sh
#
# To run in other directory:
# ./tool/coverage.sh ./path/to/other/project

set -e

PROJECT_PATH="${1:-.}"
PROJECT_COVERAGE=./coverage/lcov.info

cd ${PROJECT_PATH}

rm -rf coverage
if grep -q "flutter:" pubspec.yaml; then
    flutter test --no-pub --test-randomize-ordering-seed random --coverage
else
    dart pub global activate coverage
    dart test --coverage=coverage && format_coverage --lcov --in=coverage --out=coverage/lcov.info --packages=.packages --report-on=lib
fi
lcov --remove ${PROJECT_COVERAGE} -o ${PROJECT_COVERAGE} \
    '**/*.g.dart' \
    '**/*.gen.dart'
genhtml ${PROJECT_COVERAGE} -o coverage
pub run test_coverage_badge

echo ""
echo "Finished! To see coverage, run:"
echo ""
echo "  open coverage/index.html"
echo ""
