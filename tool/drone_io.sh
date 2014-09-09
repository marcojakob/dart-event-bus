# -----------------------------------
# Script that builds Dart app and pushes it to gh-pages.
#
# Set following variables:
# -----------------------------------
build_folder='example'
github_repo='git@github.com:marcojakob/dart-event-bus.git'

# -----------------------------------
# Build.
# -----------------------------------
pub install
pub build ${build_folder}

# -----------------------------------
# Create tmp branch with just the built files.
# -----------------------------------
git checkout --orphan tmp
# Remove everything except 'build'.
find . -maxdepth 1 ! -name 'build' ! -name '.*' | xargs rm -rf
# Move build subfolder to root.
mv build/${build_folder}/* .
rm -rf build
rm .gitignore
git add -A
git commit -m 'initial commit from drone'
git fetch

# -----------------------------------
# Replace files on gh-pages branch with files on tmp branch.
# -----------------------------------
# Test if gh-pages exists.
if git show-ref --verify --quiet refs/remotes/origin/gh-pages
then
  git checkout gh-pages
  rm -rf
  git checkout tmp *
  git add -A
  # Test if we have something to commit.
  if ! git diff-index --quiet --cached HEAD
  then
    git commit -m 'auto commit from drone'
  else
    echo There were no changes, we have nothing to commit!
  fi
else
  echo No gh-pages branch, initializing gh-pages!
  git checkout -b gh-pages
fi

# -----------------------------------
# Push gh-pages branch.
# -----------------------------------
git remote set-url origin ${github_repo}
git push origin gh-pages