#!/bin/bash

# Flutter QUIC Release Script - Version Bumping Only
# GitHub Actions will handle publishing automatically
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}🚀 Flutter QUIC Release Script${NC}"
echo -e "${YELLOW}📋 This script will: bump version → update changelog → commit → tag${NC}"
echo -e "${YELLOW}📤 GitHub Actions will automatically publish when you push the tag${NC}"
echo ""

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
echo ""

# Ask for version bump type and suggest new version
echo -e "${GREEN}Select version bump type:${NC}"
echo "1) patch (0.1.0-beta.4 → 0.1.0-beta.5)"
echo "2) minor (0.1.0-beta.4 → 0.1.1-beta.1)" 
echo "3) major (0.1.0-beta.4 → 0.2.0-beta.1)"
echo "4) prerelease (0.1.0-beta.4 → 0.1.0-beta.5)"
echo "5) release (0.1.0-beta.4 → 0.1.0)"
echo "6) custom (enter your own version)"
read -p "Choose (1-6): " bump_type

case $bump_type in
    1|4) # patch/prerelease - increment beta number
        if [[ $CURRENT_VERSION =~ ([0-9]+\.[0-9]+\.[0-9]+)-beta\.([0-9]+) ]]; then
            BASE="${BASH_REMATCH[1]}"
            BETA_NUM="${BASH_REMATCH[2]}"
            NEW_BETA=$((BETA_NUM + 1))
            SUGGESTED_VERSION="$BASE-beta.$NEW_BETA"
        else
            echo -e "${RED}❌ Current version format not recognized for patch bump${NC}"
            exit 1
        fi
        ;;
    2) # minor
        if [[ $CURRENT_VERSION =~ ([0-9]+)\.([0-9]+)\.([0-9]+) ]]; then
            MAJOR="${BASH_REMATCH[1]}"
            MINOR="${BASH_REMATCH[2]}"
            NEW_MINOR=$((MINOR + 1))
            SUGGESTED_VERSION="$MAJOR.$NEW_MINOR.0-beta.1"
        else
            echo -e "${RED}❌ Current version format not recognized for minor bump${NC}"
            exit 1
        fi
        ;;
    3) # major
        if [[ $CURRENT_VERSION =~ ([0-9]+)\.([0-9]+)\.([0-9]+) ]]; then
            MAJOR="${BASH_REMATCH[1]}"
            NEW_MAJOR=$((MAJOR + 1))
            SUGGESTED_VERSION="$NEW_MAJOR.0.0-beta.1"
        else
            echo -e "${RED}❌ Current version format not recognized for major bump${NC}"
            exit 1
        fi
        ;;
    5) # release
        if [[ $CURRENT_VERSION =~ ([0-9]+\.[0-9]+\.[0-9]+)-beta\.[0-9]+ ]]; then
            SUGGESTED_VERSION="${BASH_REMATCH[1]}"
        else
            echo -e "${RED}❌ Current version is not a beta version${NC}"
            exit 1
        fi
        ;;
    6) # custom
        SUGGESTED_VERSION=""
        ;;
    *)
        echo -e "${RED}❌ Invalid choice${NC}"
        exit 1
        ;;
esac

if [[ $bump_type == "6" ]]; then
    read -p "Enter custom version (e.g., 0.1.0-beta.7): " NEW_VERSION
else
    echo -e "${GREEN}Suggested new version: $SUGGESTED_VERSION${NC}"
    read -p "Press Enter to use suggested version, or type custom version: " custom_input
    
    if [[ -n "$custom_input" ]]; then
        NEW_VERSION="$custom_input"
    else
        NEW_VERSION="$SUGGESTED_VERSION"
    fi
fi

echo ""
echo -e "${GREEN}New version will be: $NEW_VERSION${NC}"
read -p "Continue with this version? (Y/n): " confirm

if [[ $confirm == [nN] ]]; then
    echo -e "${YELLOW}⚠️  Release cancelled${NC}"
    exit 0
fi

echo ""
echo -e "${GREEN}🔄 Starting release process...${NC}"

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

# Commit changes
echo -e "${GREEN}📦 Committing version bump...${NC}"
git add pubspec.yaml CHANGELOG.md lib/src/rust/frb_generated*.dart rust/src/frb_generated.rs
git commit -m "chore: bump version to $NEW_VERSION

- Updated package version from $CURRENT_VERSION to $NEW_VERSION
- Updated changelog with release date
- Regenerated Flutter Rust Bridge bindings"

# Create tag
echo -e "${GREEN}🏷️  Creating tag v$NEW_VERSION...${NC}"
git tag "v$NEW_VERSION"

echo ""
echo -e "${GREEN}✅ Release preparation complete!${NC}"
echo -e "${YELLOW}📋 What was done:${NC}"
echo -e "   • Version bumped: $CURRENT_VERSION → $NEW_VERSION"
echo -e "   • Changelog updated with release date"
echo -e "   • Changes committed to git"
echo -e "   • Tag v$NEW_VERSION created"
echo ""
echo -e "${GREEN}📤 Next steps:${NC}"
echo -e "   1. Push to GitHub: ${YELLOW}git push origin main && git push origin v$NEW_VERSION${NC}"
echo -e "   2. GitHub Actions will automatically publish to pub.dev"
echo -e "   3. Monitor: https://github.com/ShankarKakumani/flutter_quic/actions"
echo ""

# Ask if should push to GitHub
read -p "Push to GitHub now? (Y/n): " push_confirm

if [[ $push_confirm != [nN] ]]; then
    echo -e "${GREEN}📤 Pushing to GitHub...${NC}"
    git push origin main
    git push origin "v$NEW_VERSION"
    echo ""
    echo -e "${GREEN}🎉 Release $NEW_VERSION completed!${NC}"
    echo -e "${YELLOW}📋 Monitor the automated publishing:${NC}"
    echo -e "   • GitHub Actions: https://github.com/ShankarKakumani/flutter_quic/actions"
    echo -e "   • pub.dev: https://pub.dev/packages/flutter_quic/versions"
else
    echo ""
    echo -e "${YELLOW}⚠️  Not pushed to GitHub yet. Run when ready:${NC}"
    echo -e "${YELLOW}git push origin main && git push origin v$NEW_VERSION${NC}"
fi 