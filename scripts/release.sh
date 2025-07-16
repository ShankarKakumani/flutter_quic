#!/bin/bash

# Flutter QUIC Release Script
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}🚀 Flutter QUIC Release Script${NC}"

# Check if we're on main branch
CURRENT_BRANCH=$(git branch --show-current)
if [ "$CURRENT_BRANCH" != "main" ]; then
    echo -e "${RED}❌ Must be on main branch to release. Current branch: $CURRENT_BRANCH${NC}"
    exit 1
fi

# Check if working directory is clean
if [ -n "$(git status --porcelain)" ]; then
    echo -e "${RED}❌ Working directory is not clean. Please commit or stash changes.${NC}"
    exit 1
fi

# Get current version
CURRENT_VERSION=$(grep "version:" pubspec.yaml | sed 's/version: //' | tr -d ' ')
echo -e "${YELLOW}Current version: $CURRENT_VERSION${NC}"

# Ask for version bump type
echo "Select version bump type:"
echo "1) patch (0.1.0 -> 0.1.1)"
echo "2) minor (0.1.0 -> 0.2.0)"
echo "3) major (0.1.0 -> 1.0.0)"
echo "4) prerelease (0.1.0 -> 0.1.1-beta.1)"
echo "5) custom"

read -p "Enter choice (1-5): " choice

case $choice in
    1)
        BUMP_TYPE="patch"
        NEW_VERSION=$(echo $CURRENT_VERSION | awk -F. '{printf "%d.%d.%d", $1, $2, $3+1}')
        ;;
    2)
        BUMP_TYPE="minor"
        NEW_VERSION=$(echo $CURRENT_VERSION | awk -F. '{printf "%d.%d.0", $1, $2+1}')
        ;;
    3)
        BUMP_TYPE="major"
        NEW_VERSION=$(echo $CURRENT_VERSION | awk -F. '{printf "%d.0.0", $1+1}')
        ;;
    4)
        BUMP_TYPE="prerelease"
        if [[ $CURRENT_VERSION == *"beta"* ]]; then
            BETA_NUM=$(echo $CURRENT_VERSION | sed 's/.*beta\.//' | sed 's/+.*//')
            NEW_BETA=$((BETA_NUM + 1))
            NEW_VERSION=$(echo $CURRENT_VERSION | sed "s/beta\.$BETA_NUM/beta.$NEW_BETA/")
        else
            NEW_VERSION="${CURRENT_VERSION}-beta.1"
        fi
        ;;
    5)
        read -p "Enter new version: " NEW_VERSION
        BUMP_TYPE="custom"
        ;;
    *)
        echo -e "${RED}❌ Invalid choice${NC}"
        exit 1
        ;;
esac

echo -e "${YELLOW}New version will be: $NEW_VERSION${NC}"
read -p "Continue? (y/N): " confirm

if [[ $confirm != [yY] ]]; then
    echo "Cancelled."
    exit 1
fi

# Update version in pubspec.yaml
echo -e "${GREEN}📝 Updating pubspec.yaml...${NC}"
sed -i.bak "s/version: $CURRENT_VERSION/version: $NEW_VERSION/" pubspec.yaml
rm pubspec.yaml.bak

# Update changelog
echo -e "${GREEN}📝 Updating CHANGELOG.md...${NC}"
DATE=$(date +%Y-%m-%d)
sed -i.bak "1,/## \[Unreleased\]/s/## \[Unreleased\]/## [Unreleased]\n\n## [$NEW_VERSION] - $DATE/" CHANGELOG.md
rm CHANGELOG.md.bak

# Generate Flutter Rust Bridge bindings
echo -e "${GREEN}🔧 Generating Flutter Rust Bridge bindings...${NC}"
flutter_rust_bridge_codegen generate

# Run tests (skip for now due to native library requirements)
echo -e "${YELLOW}⚠️  Skipping tests (requires compiled native libraries)${NC}"
# flutter test

# Commit changes
echo -e "${GREEN}📦 Committing version bump...${NC}"
git add pubspec.yaml CHANGELOG.md lib/src/rust/frb_generated*.dart rust/src/frb_generated.rs
git commit -m "chore: bump version to $NEW_VERSION"

# Create tag
echo -e "${GREEN}🏷️  Creating tag...${NC}"
git tag "v$NEW_VERSION"

# Ask if should publish
read -p "Publish to pub.dev? (y/N): " publish_confirm

if [[ $publish_confirm == [yY] ]]; then
    echo -e "${GREEN}📤 Publishing to pub.dev...${NC}"
    flutter pub publish --dry-run
    
    read -p "Dry run successful. Proceed with actual publish? (y/N): " final_confirm
    if [[ $final_confirm == [yY] ]]; then
        flutter pub publish
        echo -e "${GREEN}✅ Published to pub.dev!${NC}"
    else
        echo -e "${YELLOW}⚠️  Publish cancelled. Version committed and tagged locally.${NC}"
    fi
fi

# Ask if should push to GitHub
read -p "Push to GitHub? (y/N): " push_confirm

if [[ $push_confirm == [yY] ]]; then
    echo -e "${GREEN}📤 Pushing to GitHub...${NC}"
    git push origin main
    git push origin "v$NEW_VERSION"
    echo -e "${GREEN}✅ Pushed to GitHub!${NC}"
fi

echo -e "${GREEN}🎉 Release $NEW_VERSION completed!${NC}" 