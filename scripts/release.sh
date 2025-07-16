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

# Calculate what each bump type would produce
if [[ $CURRENT_VERSION =~ ([0-9]+)\.([0-9]+)\.([0-9]+)-beta ]]; then
    MAJOR="${BASH_REMATCH[1]}"
    MINOR="${BASH_REMATCH[2]}"
    PATCH="${BASH_REMATCH[3]}"
    
    PATCH_VERSION="$MAJOR.$MINOR.$((PATCH + 1))-beta"
    MINOR_VERSION="$MAJOR.$((MINOR + 1)).0-beta"
    MAJOR_VERSION="$((MAJOR + 1)).0.0-beta"
    RELEASE_VERSION="$MAJOR.$MINOR.$PATCH"
elif [[ $CURRENT_VERSION =~ ([0-9]+)\.([0-9]+)\.([0-9]+)-beta\.([0-9]+) ]]; then
    # Handle old format (0.1.0-beta.4) 
    MAJOR="${BASH_REMATCH[1]}"
    MINOR="${BASH_REMATCH[2]}"
    PATCH="${BASH_REMATCH[3]}"
    
    PATCH_VERSION="$MAJOR.$MINOR.$((PATCH + 1))-beta"
    MINOR_VERSION="$MAJOR.$((MINOR + 1)).0-beta"
    MAJOR_VERSION="$((MAJOR + 1)).0.0-beta"
    RELEASE_VERSION="$MAJOR.$MINOR.$PATCH"
else
    # Fallback for unrecognized formats
    PATCH_VERSION="(format not recognized)"
    MINOR_VERSION="(format not recognized)"
    MAJOR_VERSION="(format not recognized)"
    RELEASE_VERSION="(format not recognized)"
fi

# Ask for version bump type and suggest new version
echo -e "${GREEN}Select version bump type:${NC}"
echo "1) patch ($CURRENT_VERSION → $PATCH_VERSION)"
echo "2) minor ($CURRENT_VERSION → $MINOR_VERSION)" 
echo "3) major ($CURRENT_VERSION → $MAJOR_VERSION)"
echo "4) release ($CURRENT_VERSION → $RELEASE_VERSION)"
echo "5) custom (enter your own version)"
read -p "Choose (1-5): " bump_type

case $bump_type in
    1) # patch - increment patch number
        if [[ $CURRENT_VERSION =~ ([0-9]+)\.([0-9]+)\.([0-9]+)-beta ]]; then
            MAJOR="${BASH_REMATCH[1]}"
            MINOR="${BASH_REMATCH[2]}"
            PATCH="${BASH_REMATCH[3]}"
            NEW_PATCH=$((PATCH + 1))
            SUGGESTED_VERSION="$MAJOR.$MINOR.$NEW_PATCH-beta"
        elif [[ $CURRENT_VERSION =~ ([0-9]+)\.([0-9]+)\.([0-9]+)-beta\.([0-9]+) ]]; then
            # Handle old format (0.1.0-beta.4) and convert to new format
            MAJOR="${BASH_REMATCH[1]}"
            MINOR="${BASH_REMATCH[2]}"
            PATCH="${BASH_REMATCH[3]}"
            NEW_PATCH=$((PATCH + 1))
            SUGGESTED_VERSION="$MAJOR.$MINOR.$NEW_PATCH-beta"
        else
            echo -e "${RED}❌ Current version format not recognized for patch bump${NC}"
            exit 1
        fi
        ;;
    2) # minor - increment minor number, reset patch
        if [[ $CURRENT_VERSION =~ ([0-9]+)\.([0-9]+)\.([0-9]+) ]]; then
            MAJOR="${BASH_REMATCH[1]}"
            MINOR="${BASH_REMATCH[2]}"
            NEW_MINOR=$((MINOR + 1))
            SUGGESTED_VERSION="$MAJOR.$NEW_MINOR.0-beta"
        else
            echo -e "${RED}❌ Current version format not recognized for minor bump${NC}"
            exit 1
        fi
        ;;
    3) # major - increment major number, reset minor and patch
        if [[ $CURRENT_VERSION =~ ([0-9]+)\.([0-9]+)\.([0-9]+) ]]; then
            MAJOR="${BASH_REMATCH[1]}"
            NEW_MAJOR=$((MAJOR + 1))
            SUGGESTED_VERSION="$NEW_MAJOR.0.0-beta"
        else
            echo -e "${RED}❌ Current version format not recognized for major bump${NC}"
            exit 1
        fi
        ;;
    4) # release - remove beta suffix
        if [[ $CURRENT_VERSION =~ ([0-9]+\.[0-9]+\.[0-9]+)-beta ]]; then
            SUGGESTED_VERSION="${BASH_REMATCH[1]}"
        elif [[ $CURRENT_VERSION =~ ([0-9]+\.[0-9]+\.[0-9]+)-beta\.([0-9]+) ]]; then
            # Handle old format (0.1.0-beta.4) and convert to release
            SUGGESTED_VERSION="${BASH_REMATCH[1]}"
        else
            echo -e "${RED}❌ Current version is not a beta version${NC}"
            exit 1
        fi
        ;;
    5) # custom
        SUGGESTED_VERSION=""
        ;;
    *)
        echo -e "${RED}❌ Invalid choice${NC}"
        exit 1
        ;;
esac

if [[ $bump_type == "5" ]]; then
    read -p "Enter custom version (e.g., 0.1.5-beta): " NEW_VERSION
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

# Commit changes
echo -e "${GREEN}📦 Committing version bump...${NC}"
git add pubspec.yaml CHANGELOG.md
git commit -m "chore: bump version to $NEW_VERSION

- Updated package version from $CURRENT_VERSION to $NEW_VERSION
- Updated changelog with release date"

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