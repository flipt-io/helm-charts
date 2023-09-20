const fs = require("fs");
const yaml = require("js-yaml");
const semver = require("semver");

// get path to YAML file from command line

const filePath = process.argv[2];

// get tag from command line
const inputTag = process.argv[3];

// Read YAML file
const fileContents = fs.readFileSync(filePath, "utf8");
const data = yaml.load(fileContents);

// Get current appVersion
const currentVersion = data.appVersion;

// Compare versions
if (semver.valid(inputTag) && semver.valid(currentVersion)) {
  const diffType = semver.diff(currentVersion, inputTag);

  // Determine if it's a minor or patch bump
  if (diffType === "minor" || diffType === "patch") {
    console.log(`The appVersion was bumped with a ${diffType} change.`);
  } else {
    console.error(
      `The appVersion was bumped, but it's not a minor or patch change. It's a ${diffType} change.`
    );
    return 1;
  }

  // Update appVersion
  data.appVersion = inputTag;
  // Update chart version using same strategy
  version = data.version;
  data.version = semver.inc(version, diffType);

  // Write updated YAML back to file
  const newYaml = yaml.dump(data);
  fs.writeFileSync(filePath, newYaml, "utf8");

  console.log("The appVersion and chart version were updated.");
} else {
  console.error("Invalid version(s).");
}
